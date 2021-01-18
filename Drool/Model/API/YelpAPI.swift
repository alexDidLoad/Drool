//
//  YelpAPI.swift
//  Drool
//
//  Created by Alexander Ha on 1/13/21.
//

import UIKit

let apiKey = myYelpAPIKey

extension MapVC {
    
    //MARK: - Yelp Business Search
    func fetchBusiness(latitude: Double,
                       longitude: Double,
                       category: String,
                       limit: Int,
                       sortBy: String,
                       locale: String,
                       completionHandler: @escaping ([Restaurant]?, Error?) -> Void) {
        
        
        
        ///Create URL:
        let baseURL = "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)&categories=\(category)&limit=\(limit)&sort_by=\(sortBy)&locale=\(locale)"
        let url = URL(string: baseURL)
        
        ///GET Request:
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        ///Initialize session and task:
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(nil, error)
            }
            do {
                //Read data as JSON
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                //Create dictionary and store JSON object
                guard let resp = json as? NSDictionary else { return }
                
                //Accessing each business, setting the properties in Restaurant object and appending the object to empty restaurant array
                guard let businesses = resp.value(forKey: "businesses") as? [NSDictionary] else { return }
                var restaurantList: [Restaurant] = []
                
                for business in businesses {
                    var restaurant = Restaurant()
                    restaurant.name = business.value(forKey: "name") as? String
                    restaurant.id = business.value(forKey: "id") as? String
                    restaurant.rating = business.value(forKey: "rating") as? Float
                    restaurant.price = business.value(forKey: "price") as? String
                    restaurant.is_closed = business.value(forKey: "is_closed") as? Bool
                    restaurant.distance = business.value(forKey: "distance") as? Double
                    let address = business.value(forKey: "location.display_address") as? [String]
                    restaurant.address = address?.joined(separator: "\n")
                    
                    restaurantList.append(restaurant)
                }
                completionHandler(restaurantList, nil)
            } catch {
                print("DEBUG: Error in continuing URLSession/Datatask")
            }
        }.resume()
    }
    
    //MARK: - Yelp Phone Search
    
    func fetchYelpData(withPhoneNumber phone: String) {
        
        guard let url = URL(string: "https://api.yelp.com/v3/businesses/search/phone?phone=\(phone)") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        getData(from: request) { (response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let response = response {
                response.forEach({self.restaurants.append($0)})
            }
        }
    }
    
    func getData(from request: URLRequest, completion: @escaping ([Restaurant]?, Error?) -> Void) {
       
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(nil, error)
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                guard let resp = json as? NSDictionary else { return }
                guard let businesses = resp.value(forKey: "businesses") as? [NSDictionary] else { return }
                var restaurantList: [Restaurant] = []
                
                for business in businesses {
                    var restaurant = Restaurant()
                    restaurant.name = business.value(forKey: "name") as? String
                    restaurant.id = business.value(forKey: "id") as? String
                    restaurant.rating = business.value(forKey: "rating") as? Float
                    restaurant.price = business.value(forKey: "price") as? String
                    restaurant.is_closed = business.value(forKey: "is_closed") as? Bool
                    restaurant.distance = business.value(forKey: "distance") as? Double
                    restaurant.url = business.value(forKey: "url") as? String
                    restaurant.image_url = business.value(forKey: "image_url") as? String
                    restaurant.phone = business.value(forKey: "phone") as? String
                    
                    let address = (business["location"] as? [String: Any])?["address1"] as? String
                    restaurant.address = address
                    let latitude = (business["coordinates"] as? [String: Any])?["latitude"] as? Double
                    let longitude = (business["coordinates"] as? [String: Any])?["longitude"] as? Double
                    restaurant.latitude = latitude
                    restaurant.longitude = longitude
                    
                    restaurantList.append(restaurant)
                }
                completion(restaurantList, nil)
            } catch {
                print("DEBUG: Error in parsing json")
            }
        }
        task.resume()
    }
    
}



