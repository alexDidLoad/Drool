//
//  ViewController.swift
//  Drool
//
//  Created by Alexander Ha on 1/9/21.
//

import UIKit
import CoreLocation

private let reuseIdentifier = "CategoryCell"
private let categoryImageNames = ["american", "french", "italian", "mexican", "japanese", "chinese", "thai", "korean"]

class HomeVC: UIViewController {
    
    //MARK: - UIComponents
    
    //MARK: - Properties
    
    
    private var locationManager: CLLocationManager!
    private var tableView: UITableView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        enableLocationServices()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        configureTableView()
    }
    
    private func configureTableView() {
        tableView = UITableView()
        tableView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.rowHeight = 210
        tableView.separatorColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         leading: view.leadingAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         trailing: view.trailingAnchor)
    }
    
}

//MARK: - UITableViewDelegate & DataSource

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryImageNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
        cell.cellImageView.image = UIImage(named: categoryImageNames[indexPath.row])
        cell.categoryLabel.text = "\(categoryImageNames[indexPath.row].capitalized) Cuisine"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    
    
}

//MARK: - CLLocationManagerDelegate

extension HomeVC: CLLocationManagerDelegate {
    
    func enableLocationServices() {
        let locationVC = LocationRequestController()
        locationVC.modalPresentationStyle = .fullScreen
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("not determined")
            DispatchQueue.main.async {
                locationVC.locationManager = self.locationManager
                self.present(locationVC, animated: true, completion: nil)
            }
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
            DispatchQueue.main.async {
                locationVC.locationManager = self.locationManager
                self.present(locationVC, animated: true, completion: nil)
            }
        case .authorizedAlways:
            print("always authorized")
        case .authorizedWhenInUse:
            print("only when in use")
        @unknown default:
            print("unknown case")
        }
    }
}
