//
//  FavoritesVC.swift
//  Drool
//
//  Created by Alexander Ha on 1/9/21.
//

import UIKit

let favoriteReuseIdentifier = "favoritesCell"

class FavoritesVC: UIViewController {
    
    //MARK: - UIComponents
    
    private var favoritesTableView: UITableView!
    
    //MARK: - Properties
    
    var favoritesData = favoritesCellDataSource()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        configureTableView()
    }
    
    private func configureTableView() {
        favoritesTableView = UITableView()
        favoritesTableView.separatorStyle = .none
        favoritesTableView.backgroundColor = .clear
        favoritesTableView.rowHeight = 210
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = favoritesData
        favoritesTableView.register(FavoritesCell.self, forCellReuseIdentifier: favoriteReuseIdentifier)
        
        view.addSubview(favoritesTableView)
        favoritesTableView.addConstraintsToFillView(view: view)
    }
}

//MARK: - UITableViewDelegate

extension FavoritesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}
