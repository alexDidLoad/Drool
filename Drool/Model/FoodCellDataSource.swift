//
//  FoodCellDataSource.swift
//  Drool
//
//  Created by Alexander Ha on 1/10/21.
//

import UIKit

let americanFood: [String] = ["All Foods", "Burgers", "Fried Chicken", "Steak", "Soup and Salad", "Hotdog", "Fast food"]
let frenchFood: [String] = ["All Foods", "Pastries", "French Bistro", "Wine and Cheese"]
let italianFood: [String] = ["All Foods", "Pasta", "Pizza", "Gelato", ]
let mexicanFood: [String] = ["All Foods", "Tacos", "Burritos", "Elote", "Mole", "Tamales" ]
let japaneseFood: [String] = ["All Foods", "Sushi", "Ramen", "Udon", "Japanese Curry", "Tempura"]
let chineseFood: [String] = ["All Foods", "Fried Rice", "Hot pot", "Dim sum", "Chinese Noodles"]
let thaiFood: [String] = ["All Foods", "Tom yum soup", "Pad Thai", "Thai Curry"]
let koreanFood: [String] = ["All Foods", "Korean Bbq", "Bulgogi", "Korean Stew", "Bibimbap", "Jap chae"]

class FoodCellDataSource: NSObject, UITableViewDataSource {
    
    //MARK: - Properties
    
    private var numberOfRows: Int!
    var selectedFood: [String]!
    
    var food: Food! {
        didSet {
            numberOfRows = calculateNumberOfRows()
        }
    }
    //MARK: - UITableViewDataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = numberOfRows else { return 0}
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: foodReuseIdentifier, for: indexPath) as! FoodCell
        //        cell.cellImageView.image = UIImage(named: categoryImageNames[indexPath.row])
        cell.categoryLabel.text = "\(selectedFood[indexPath.row].capitalized)"
        return cell
    }
    
    //MARK: - Helpers
    
    private func calculateNumberOfRows() -> Int {
        switch food.type {
        case .none:
            return 0
        case .some(.French):
            selectedFood = frenchFood
            return frenchFood.count
        case .some(.Italian):
            selectedFood = italianFood
            return italianFood.count
        case .some(.Mexican):
            selectedFood = mexicanFood
            return mexicanFood.count
        case .some(.Japanese):
            selectedFood = japaneseFood
            return japaneseFood.count
        case .some(.Chinese):
            selectedFood = chineseFood
            return chineseFood.count
        case .some(.Thai):
            selectedFood = thaiFood
            return thaiFood.count
        case .some(.Korean):
            selectedFood = koreanFood
            return koreanFood.count
        case .some(.American):
            selectedFood = americanFood
            return americanFood.count
        }
    }
}
