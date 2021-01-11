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
        view.backgroundColor = .black
        configureCategoryTableView()
        configureFoodTableView()
    }
    
    private func configureCategoryTableView() {
        
        categoryTableView = UITableView()
        categoryTableView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
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
        foodTableView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        foodTableView.rowHeight = 210
        foodTableView.separatorColor = .white
        foodTableView.delegate = self
        foodTableView.dataSource = foodData
        foodTableView.register(FoodCell.self, forCellReuseIdentifier: foodReuseIdentifier)
        
        view.addSubview(foodTableView)
        foodTableView.setWidth(width: view.frame.width)
        foodTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: categoryTableView.trailingAnchor,
                             bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    private func animateTableView(_ tableView: UITableView, atIndexPath indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: .zero, options: .curveEaseInOut) {
            selectedCell?.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        } completion: { (_) in
            selectedCell?.transform = .identity
        }
        UIView.animate(withDuration: 0.8, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: .zero, options: .curveEaseInOut) {
            tableView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: - UITableViewDelegate

extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == categoryTableView {
            categoryTableViewCenterX.isActive = false
            categoryTableViewTrailing.isActive = true
            animateTableView(tableView, atIndexPath: indexPath)
            
            //change food.type to the selected cuisine
            food = Food(cuisine: categoryImageNames[indexPath.row])
            foodData.food = self.food
            //have foodtableview reload its image data
            foodTableView.reloadData()
        } else {
            print(foodData.selectedFood[indexPath.row])
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
