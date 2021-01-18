//
//  CategoryCellDataSource.swift
//  Drool
//
//  Created by Alexander Ha on 1/10/21.
//

import UIKit

class CategoryCellDataSource: NSObject, UITableViewDataSource {
    
    //MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryImageNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryReuseIdentifier, for: indexPath) as! CategoryCell
        cell.cellImageView.image = UIImage(named: categoryImageNames[indexPath.row])
        cell.categoryLabel.text = "\(categoryImageNames[indexPath.row].capitalized) Cuisine"
        return cell
    }
}
