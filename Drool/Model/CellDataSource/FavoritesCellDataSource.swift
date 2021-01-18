//
//  FavoritesCell.swift
//  Drool
//
//  Created by Alexander Ha on 1/15/21.
//

import UIKit

class FavoritesCellDataSource: NSObject, UITableViewDataSource {
    
    //MARK: - Properties
    
    var favorites: [Favorite]?
    var favoritesVC: FavoritesVC?
    
    //MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let favorites = favorites else { return 0 }
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: favoriteReuseIdentifier, for: indexPath) as! FavoritesCell
        if let favorites = favorites {
            cell.favorite = favorites[indexPath.row]
        }
        return cell
    }
    
}
