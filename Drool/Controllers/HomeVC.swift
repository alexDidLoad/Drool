//
//  ViewController.swift
//  Drool
//
//  Created by Alexander Ha on 1/9/21.
//

import UIKit
import CoreLocation

let categoryReuseIdentifier = "CategoryCell"
let foodReuseIdentifier = "FoodCell"
let categoryImageNames = ["american", "french", "italian", "mexican", "japanese", "chinese", "thai", "korean"]

class HomeVC: UIViewController {
    
    //MARK: - UIComponents
    
    private var categoryTableView: UITableView!
    private var categoryTableViewTrailing: NSLayoutConstraint!
    private var categoryTableViewCenterX: NSLayoutConstraint!
    
    //MARK: - Properties
    
    private var locationManager: CLLocationManager!
    private let categoryData = CategoryCellDataSource()
    private var foodVC = FoodVC()
    private var foodData = FoodCellDataSource()
    private var food: Food!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        enableLocationServices()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .black
        configureCategoryTableView()
    }
    
    private func configureCategoryTableView() {
        
        categoryTableView = UITableView()
        categoryTableView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        categoryTableView.rowHeight = 210
        categoryTableView.separatorStyle = .none
        categoryTableView.delegate = self
        categoryTableView.dataSource = categoryData
        categoryTableView.register(CategoryCell.self, forCellReuseIdentifier: categoryReuseIdentifier)
        
        view.addSubview(categoryTableView)
        categoryTableView.setWidth(width: view.frame.width)
        categoryTableView.addConstraintsToFillView(view: view)
    }
}

//MARK: - UITableViewDelegate

extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        animateTableView(tableView, atIndexPath: indexPath, presentingVC: foodVC)
        
        //change food.type to the selected cuisine
        food = Food(cuisine: categoryImageNames[indexPath.row])
        foodData.food = self.food
        foodVC.foodData = foodData
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
