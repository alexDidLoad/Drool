//
//  FoodVC.swift
//  Drool
//
//  Created by Alexander Ha on 1/11/21.
//

import UIKit

class FoodVC: UIViewController {
    
    //MARK: - UIComponents
    
    private var foodTableView: UITableView!
    
    //MARK: - Properties
    
    var mapController: MapVC!
    var foodData: FoodCellDataSource! {
        didSet {
            DispatchQueue.main.async {
                self.foodTableView?.reloadData()
            }
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .black
        configureFoodTableView()
    }
    
    private func configureFoodTableView() {
        foodTableView = UITableView()
        foodTableView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        foodTableView.rowHeight = 210
        foodTableView.separatorStyle = .none
        foodTableView.delegate = self
        foodTableView.dataSource = foodData
        foodTableView.register(FoodCell.self, forCellReuseIdentifier: foodReuseIdentifier)
        
        view.addSubview(foodTableView)
        foodTableView.addConstraintsToFillView(view: view)
    }
}
//MARK: - UITableViewDelegate Methods

extension FoodVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mapController = MapVC()
        mapController.delegate = self
        mapController.modalPresentationStyle = .fullScreen
        mapController.foodCategory = foodData.selectedCategory[indexPath.row]
        animateTableView(tableView, atIndexPath: indexPath, presentingVC: mapController)
    }
}

//MARK: - MapViewController Delegate

extension FoodVC: MapViewControllerDelegate {
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}
