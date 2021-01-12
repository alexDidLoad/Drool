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
    
    
    //MARK: - Properties
    
    private var mapView: MKMapView!
    private var locationManager: CLLocationManager!
    private var route: MKRoute?
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        configureMapView()
        
        
        
    }
    
    private func configureMapView() {
        mapView = MKMapView()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        view.addSubview(mapView)
        mapView.addConstraintsToFillView(view: view)
    }
    
}

//MARK: - MapViewDelegate

extension MapVC: MKMapViewDelegate {
    
}

