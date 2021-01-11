//
//  FoodCellDataSource.swift
//  Drool
//
//  Created by Alexander Ha on 1/10/21.
//

import UIKit

class FoodCellDataSource: NSObject, UITableViewDataSource {
    
    //MARK: - Properties
    
    var food: Food! {
        didSet {
            numberOfRows = calculateNumberOfRows()
        }
    }
    private var numberOfRows: Int!
    
    private let americanFood: [String] = ["All Foods", "Burgers", "Fried Chicken", "Steak", "Soup and Salad", "Hotdog", "Fast food"]
    private let frenchFood: [String] = ["All Foods", "Pastries", "French Bistro", "Wine and Cheese"]
    private let italianFood: [String] = ["All Foods", "Pasta", "Pizza", "Gelato", ]
    private let mexicanFood: [String] = ["All Foods", "Tacos", "Burritos", "Elote", "Mole", "Tamales" ]
    private let japaneseFood: [String] = ["All Foods", "Sushi", "Ramen", "Udon", "Japanese Curry", "Tempura"]
    private let chineseFood: [String] = ["All Foods", "Fried Rice", "Hot pot", "Dim sum", "Chinese Noodles"]
    private let thaiFood: [String] = ["All Foods", "Tom yum soup", "Pad Thai", "Thai Curry"]
    private let koreanFood: [String] = ["All Foods", "Korean Bbq", "Bulgogi", "Korean Stew", "Bibimbap", "Jap chae"]
    
    //MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = numberOfRows else { return 0}
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: foodReuseIdentifier, for: indexPath) as! FoodCell
        //        cell.cellImageView.image = UIImage(named: categoryImageNames[indexPath.row])
        //        cell.categoryLabel.text = "\(categoryImageNames[indexPath.row].capitalized) Cuisine"
        return cell
    }
    
    //MARK: - Helpers
    
    private func calculateNumberOfRows() -> Int {
        switch food.type {
        case .none:
            return 0
        case .some(.French):
            return frenchFood.count
        case .some(.Italian):
            return italianFood.count
        case .some(.Mexican):
            return mexicanFood.count
        case .some(.Japanese):
            return japaneseFood.count
        case .some(.Chinese):
            return chineseFood.count
        case .some(.Thai):
            return thaiFood.count
        case .some(.Korean):
            return koreanFood.count
        case .some(.American):
            return americanFood.count
        }
    }
}
