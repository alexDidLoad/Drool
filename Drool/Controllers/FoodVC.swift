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
    
    var foodData: FoodCellDataSource! {
        didSet {
            foodTableView?.reloadData()
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
        let mapController = MapVC()
        mapController.modalPresentationStyle = .fullScreen
        
        animateTableView(tableView, atIndexPath: indexPath, presentingVC: mapController)
    }
    
}
