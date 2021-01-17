//
//  Restaurant.swift
//  Drool
//
//  Created by Alexander Ha on 1/13/21.
//

import Foundation

struct Restaurant: Codable {
    
    var name            : String?
    var id              : String?
    var rating          : Float?
    var price           : String?
    var is_closed       : Bool?
    var distance        : Double?
    var address         : String?
    var latitude        : Double?
    var longitude       : Double?
    var url             : String?
    var image_url       : String?
}
