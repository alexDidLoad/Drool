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
    
    private var foodTableView: UITableView!
    private var foodTableViewLeading: NSLayoutConstraint!
    private var foodTableViewCenterX: NSLayoutConstraint!
    
    //MARK: - Properties
    
    private var locationManager: CLLocationManager!
    private let categoryData = CategoryCellDataSource()
    private let foodData = FoodCellDataSource()
    private var food: Food!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        enableLocationServices()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        configureCategoryTableView()
        configureFoodTableView()
    }
    
    private func configureCategoryTableView() {
        
        categoryTableView = UITableView()
        categoryTableView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        categoryTableView.rowHeight = 210
        categoryTableView.separatorColor = .white
        categoryTableView.delegate = self
        categoryTableView.dataSource = categoryData
        categoryTableView.register(CategoryCell.self, forCellReuseIdentifier: categoryReuseIdentifier)
        
        view.addSubview(categoryTableView)
        categoryTableView.setWidth(width: view.frame.width)
        categoryTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                 bottom: view.safeAreaLayoutGuide.bottomAnchor)
        //animatable constraints
        categoryTableViewTrailing = categoryTableView.trailingAnchor.constraint(equalTo: view.leadingAnchor)
        categoryTableViewTrailing.isActive = false
        categoryTableViewCenterX = categoryTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        categoryTableViewCenterX.isActive = true
    }
    
    private func configureFoodTableView() {
        foodTableView = UITableView()
        foodTableView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        foodTableView.rowHeight = 210
        foodTableView.separatorColor = .white
        foodTableView.delegate = self
        foodTableView.dataSource = foodData
        foodTableView.register(FoodCell.self, forCellReuseIdentifier: foodReuseIdentifier)
        
        view.addSubview(foodTableView)
        foodTableView.setWidth(width: view.frame.width)
        foodTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor)
        //animatable constraints
        foodTableViewLeading = foodTableView.leadingAnchor.constraint(equalTo: view.trailingAnchor)
        foodTableViewLeading.isActive = true
        foodTableViewCenterX = foodTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        foodTableViewCenterX.isActive = false
    }
}

//MARK: - UITableViewDelegate

extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == categoryTableView {
            categoryTableViewCenterX.isActive = false
            categoryTableViewTrailing.isActive = true
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: .zero, options: .curveEaseInOut) {
                self.view.layoutIfNeeded()
            }
            foodTableViewLeading.isActive = false
            foodTableViewCenterX.isActive = true
            UIView.animate(withDuration: 0.5, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: .zero, options: .curveEaseInOut) {
                self.view.layoutIfNeeded()
            }
            //change food.type to the selected cuisine
            food = Food(cuisine: categoryImageNames[indexPath.row])
            foodData.food = self.food
            //have foodtableview reload its image data
            foodTableView.reloadData()
        } else {
            print(food.type)
        }
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
