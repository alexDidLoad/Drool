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
    
    private var mapSearchView = MapSearchView()
    private var mapView = MKMapView()
    
    //MARK: - Properties
    
    var foodCategory: String! {
        didSet {
            centerOnUserLocation(shouldLoadAnnotations: true)
        }
    }
    private lazy var locationManager = HomeVC().locationManager
    private var route: MKRoute?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
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
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        if shouldLoadAnnotations {
            loadAnnotations(withSearchQuery: foodCategory)
        }
        mapView.setRegion(region, animated: true)
        mapSearchView.expansionState = .NotExpanded
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
                print("DEBUG: Error in starting search reqeust: \(error!.localizedDescription)")
                return
            }
            completion(response, nil)
        }
    }
    
    private func loadAnnotations(withSearchQuery query: String) {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        searchBy(naturalLanguageQuery: query, region: region, coordinates: coordinate) { (response, error) in
            guard let reponse = response else { return }
            
            response?.mapItems.forEach({ mapItem in
                let annotation = MKPointAnnotation()
                annotation.title = mapItem.name
                annotation.coordinate = mapItem.placemark.coordinate
                self.mapView.addAnnotation(annotation)
            })
            DispatchQueue.main.async {
                self.mapSearchView.searchResults = reponse.mapItems
            }
        }
    }
}

//MARK: - MapViewDelegate

extension MapVC: MKMapViewDelegate {
    
}

//MARK: - MapSearchViewDelegate

extension MapVC: MapSearchViewDelegate {
    
}

