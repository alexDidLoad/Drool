//
//  MapController.swift
//  Drool
//
//  Created by Alexander Ha on 1/11/21.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {
    
    //MARK: - UIComponents
    
    private let centerUserLocationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.viewfinder"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.3020650255, green: 0.6180910299, blue: 0.9686274529, alpha: 1)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 13
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowOpacity = 0.3
        button.imageView?.setDimensions(height: 40, width: 45)
        button.addTarget(self, action: #selector(handleCenterLocation), for: .touchUpInside)
        return button
    }()
    
    private let exitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.imageView?.addConstraintsToFillView(view: button)
        button.imageView?.contentMode = .scaleAspectFit
        button.setDimensions(height: 40, width: 40)
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        button.tintColor = UIColor.lightGray.withAlphaComponent(0.5)
        button.addTarget(self, action: #selector(handleExit), for: .touchUpInside)
        return button
    }()
    
    var mapSearchView = MapSearchView()
   
    private var mapView = MKMapView()
    
    //MARK: - Properties
    
    
    var restaurantNumber: [String]! {
        didSet {
            restaurantNumber.forEach { (number) in
                self.fetchBusiness(withPhoneNumber: number) { (response, error) in
                    if let response = response {
                        response.forEach({self.restaurants.append($0)})
                    } else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    var restaurants: [Restaurant] = [] {
        didSet {
            mapSearchView.restaurants = self.restaurants
        }
    }
    var foodCategory: String! {
        didSet {
            centerOnUserLocation(shouldLoadAnnotations: true)
        }
    }
    private var mapAnnotation: MKPointAnnotation!
    private lazy var locationManager = HomeVC().locationManager
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapSearchView.expansionState = .NotExpanded
    }
    
    //MARK: - Selectors
    
    @objc func handleCenterLocation() {
        centerOnUserLocation(shouldLoadAnnotations: false)
    }
    
    @objc func handleExit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        configureMapView()
        view.addSubview(centerUserLocationButton)
        centerUserLocationButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                        trailing: view.trailingAnchor,
                                        paddingTop: 30,
                                        paddingTrailing: 16,
                                        height: 50,
                                        width: 50)
        view.addSubview(exitButton)
        exitButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          paddingTop: 8,
                          paddingLeading: 8)
        
        mapSearchView.delegate = self
        mapSearchView.mapController = self
        view.addSubview(mapSearchView)
        mapSearchView.anchor(leading: view.leadingAnchor,
                             bottom: view.bottomAnchor,
                             trailing: view.trailingAnchor,
                             paddingBottom: -(view.frame.height - 88),
                             height: view.frame.height)
    }
    
    private func configureMapView() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        view.addSubview(mapView)
        mapView.addConstraintsToFillView(view: view)
    }
    
    //MARK: - MapKit Helper Methods
    
    private func centerOnUserLocation(shouldLoadAnnotations: Bool) {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        
        if shouldLoadAnnotations {
            loadRestaurantNumbers(withSearchQuery: foodCategory)
        }
        mapView.setRegion(region, animated: true)
        mapSearchView.expansionState = .NotExpanded
    }
    
    private func zoomToFit(selectedAnnotation: MKAnnotation?) {
        if mapView.annotations.count == 0 {
            return
        }
        var topLeftCoordinate = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoordinate = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        
        if let selectedAnnotation = selectedAnnotation {
            for annotation in mapView.annotations {
                if let userAnnotation = annotation as? MKUserLocation {
                    topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, userAnnotation.coordinate.longitude)
                    topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, userAnnotation.coordinate.latitude)
                    bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, userAnnotation.coordinate.longitude)
                    bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, userAnnotation.coordinate.latitude)
                }
                if annotation.title == selectedAnnotation.title {
                    topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, annotation.coordinate.longitude)
                    topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, annotation.coordinate.latitude)
                    bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, annotation.coordinate.longitude)
                    bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, annotation.coordinate.latitude)
                }
            }
            var region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(topLeftCoordinate.latitude - (topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 0.65, topLeftCoordinate.longitude + (bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 0.65), span: MKCoordinateSpan(latitudeDelta: fabs(topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 3.0, longitudeDelta: fabs(bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 3.0))
            
            region = mapView.regionThatFits(region)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func searchBy(naturalLanguageQuery: String, region: MKCoordinateRegion, coordinates: CLLocationCoordinate2D, completion: @escaping(_ response: MKLocalSearch.Response?, _ error: NSError?) -> ()) {
        
        //Create local search request
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = naturalLanguageQuery
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                completion(nil, error! as NSError)
                return
            }
            completion(response, nil)
        }
    }
    
    private func loadRestaurantNumbers(withSearchQuery query: String) {
        guard let userLocation = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: userLocation, latitudinalMeters: 100, longitudinalMeters: 100)
        var phoneNumbers = [String]()
        
        searchBy(naturalLanguageQuery: query, region: region, coordinates: userLocation) { (response, error) in
            guard let response = response else { return }
            response.mapItems.forEach({ mapItem in
                let deleteCharacters: Set<Character> = ["(", ")", "-"]
                var mapNumber = mapItem.phoneNumber?.replacingOccurrences(of: " ", with: "")
                mapNumber?.removeAll(where: {deleteCharacters.contains($0)})
                guard let number = mapNumber else { return }
                phoneNumbers.append(number)
            })
            DispatchQueue.main.async {
                self.restaurantNumber = phoneNumbers
            }
        }
    }
}

//MARK: - MapViewDelegate

extension MapVC: MKMapViewDelegate {
    
}

//MARK: - MapSearchViewDelegate

extension MapVC: MapSearchViewDelegate {
    
    func addAnnotations(forRestaurants: [Restaurant]) {
        for restaurant in restaurants {
            mapAnnotation = MKPointAnnotation()
            mapAnnotation.title = restaurant.name
            mapAnnotation.coordinate.latitude = restaurant.latitude!
            mapAnnotation.coordinate.longitude = restaurant.longitude!
            self.mapView.addAnnotation(mapAnnotation)
        }
    }
    
    func refresh() {
        
        let allAnnotations = self.mapView.annotations
        restaurants.removeAll()
        self.mapView.removeAnnotations(allAnnotations)
        
        restaurantNumber.forEach { (number) in
            self.fetchBusiness(withPhoneNumber: number) { (response, error) in
                if let response = response {
                    response.forEach({self.restaurants.append($0)})
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func didSelectAnnotation(withMapItem mapItem: MKMapItem) {
        
        mapView.annotations.forEach { annotation in
            if annotation.title == mapItem.name {
                self.mapView.selectAnnotation(annotation, animated: true)
                self.zoomToFit(selectedAnnotation: annotation)
            } else if annotation.title != mapItem.name {
                self.mapView.removeAnnotation(annotation)
            }
        }
        
    }
}

//MARK: - MapCellDelegate

extension MapVC: MapCellDelegate {
    func getDirections(forMapItem mapItem: MKMapItem) {
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
}
