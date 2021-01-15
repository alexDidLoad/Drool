//
//  FavoritesCell.swift
//  Drool
//
//  Created by Alexander Ha on 1/15/21.
//

import UIKit

class favoritesCellDataSource: NSObject, UITableViewDataSource {
    
    //MARK: - Properties
    
    
    
    //MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: favoriteReuseIdentifier, for: indexPath) as! FavoritesCell
        
        return cell
    }
    
    
}
