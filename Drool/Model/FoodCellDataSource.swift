//
//  FoodCellDataSource.swift
//  Drool
//
//  Created by Alexander Ha on 1/10/21.
//

import UIKit

let americanFood: [String] = ["Burgers", "Fried Chicken", "Steak", "Soup and Salad", "Hotdog", "Fast food"]
let frenchFood: [String] = ["Pastries", "French Bistro", "Wine and Cheese"]
let italianFood: [String] = ["Pasta", "Pizza", "Gelato", ]
let mexicanFood: [String] = ["Tacos", "Burritos", "Elote", "Mole", "Tamales" ]
let japaneseFood: [String] = ["Sushi", "Ramen", "Udon", "Japanese Curry", "Tempura"]
let chineseFood: [String] = ["Fried Rice", "Hot pot", "Dim sum", "Chinese Noodles"]
let thaiFood: [String] = ["Tom yum soup", "Pad Thai", "Thai Curry"]
let koreanFood: [String] = ["Korean Bbq", "Bulgogi", "Korean Stew", "Bibimbap", "Jap chae"]

class FoodCellDataSource: NSObject, UITableViewDataSource {
    
    //MARK: - Properties
    
    private var numberOfRows: Int!
    private var selectedCategory: [String]!
    private var foodImage: UIImage?
    
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
        
        switch food.type {
        case .American:
            foodImage = UIImage(named: americanFood[indexPath.row].lowercased())
        case .French:
            foodImage = UIImage(named: frenchFood[indexPath.row].lowercased())
        case .Italian:
            foodImage = UIImage(named: italianFood[indexPath.row].lowercased())
        case .Mexican:
            foodImage = UIImage(named: mexicanFood[indexPath.row].lowercased())
        case .Japanese:
            foodImage = UIImage(named: japaneseFood[indexPath.row].lowercased())
        case .Chinese:
            foodImage = UIImage(named: chineseFood[indexPath.row].lowercased())
        case .Thai:
            foodImage = UIImage(named: thaiFood[indexPath.row].lowercased())
        case .Korean:
            foodImage = UIImage(named: koreanFood[indexPath.row].lowercased())
        case .none:
            foodImage = nil
        }
        
        cell.cellImageView.image = foodImage
        cell.categoryLabel.text = "\(selectedCategory[indexPath.row].capitalized)"
        return cell
    }
    
    //MARK: - Helpers
    
    private func calculateNumberOfRows() -> Int {
        switch food.type {
        case .none:
            return 0
        case .French:
            selectedCategory = frenchFood
            return frenchFood.count
        case .Italian:
            selectedCategory = italianFood
            return italianFood.count
        case .Mexican:
            selectedCategory = mexicanFood
            return mexicanFood.count
        case .Japanese:
            selectedCategory = japaneseFood
            return japaneseFood.count
        case .Chinese:
            selectedCategory = chineseFood
            return chineseFood.count
        case .Thai:
            selectedCategory = thaiFood
            return thaiFood.count
        case .Korean:
            selectedCategory = koreanFood
            return koreanFood.count
        case .American:
            selectedCategory = americanFood
            return americanFood.count
        }
    }
}
