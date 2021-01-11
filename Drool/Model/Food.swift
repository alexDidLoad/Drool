//
//  FoodType.swift
//  Drool
//
//  Created by Alexander Ha on 1/10/21.
//

import UIKit

struct Food {
    
    //MARK: - Properties
    enum cuisineType {
        case American
        case French
        case Italian
        case Mexican
        case Japanese
        case Chinese
        case Thai
        case Korean
    }
    
    var type: cuisineType!
    var cuisine: String!
    var selectedFood: [String]!
    
    //MARK: - Lifecycle
    
    init(cuisine: String) {
        self.cuisine = cuisine
        
        handleSelectedCuisine()
    }
    
    private mutating func handleSelectedCuisine() {
        switch cuisine {
        case "american":
            type = .American
        case "french":
            type = .French
        case "italian":
            type = .Italian
        case "mexican":
            type = .Mexican
        case "japanese":
            type = .Chinese
        case "chinese":
            type = .Thai
        case "thai":
            type = .Thai
        case "korean":
            type = .Korean
        default:
            print("DEBUG: Error in selecting cuisine")
        }
        
    }
    
}
