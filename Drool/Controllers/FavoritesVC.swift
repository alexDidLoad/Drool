//
//  FavoritesVC.swift
//  Drool
//
//  Created by Alexander Ha on 1/9/21.
//

import UIKit
import MapKit
import CoreData

let favoriteReuseIdentifier = "favoritesCell"

class FavoritesVC: UIViewController {
    
    //MARK: - UIComponents
    
    var favoritesTableView = UITableView()
    
    //MARK: - Properties
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var favoritesData = FavoritesCellDataSource()
    var favorites: [Favorite]?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
//        fetchRestaurants()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRestaurants()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        configureTableView()
    }
    
    private func configureTableView() {
        favoritesTableView.separatorStyle = .none
        favoritesTableView.backgroundColor = .clear
        favoritesTableView.rowHeight = 210
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = favoritesData
        favoritesTableView.register(FavoritesCell.self, forCellReuseIdentifier: favoriteReuseIdentifier)
        
        view.addSubview(favoritesTableView)
        favoritesTableView.addConstraintsToFillView(view: view)
    }
    
    func fetchRestaurants() {
        do {
            self.favoritesData.favorites = try context.fetch(Favorite.fetchRequest())
            self.favorites = try context.fetch(Favorite.fetchRequest())
            DispatchQueue.main.async {
                self.favoritesTableView.reloadData()
            }
        } catch {
            print("DEBUG: Error in fetching context")
        }
    }
}

//MARK: - UITableViewDelegate

extension FavoritesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let favorites = favorites {
            let latitude = favorites[indexPath.row].latitude
            let longitude = favorites[indexPath.row].longitude
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let placemark = MKPlacemark(coordinate: coordinates)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = favorites[indexPath.row].name
            
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
    }
}
