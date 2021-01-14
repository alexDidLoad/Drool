//
//  Extensions.swift
//  Drool
//
//  Created by Alexander Ha on 1/9/21.
//

import UIKit

//MARK: - UIView

extension UIView {
    
    func addConstraintsToFillView(view: UIView) {
        self.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingLeading: 0, paddingBottom: 0, paddingTrailing: 0)
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                leading: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                trailing: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeading: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingTrailing: CGFloat = 0,
                height: CGFloat? = nil,
                width: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: paddingLeading).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -paddingTrailing).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
    }
    
    func centerX(inView view: UIView, leadingAnchor: NSLayoutXAxisAnchor? = nil, paddingLeading: CGFloat = 0, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).isActive = true
        
        if let leading = leadingAnchor {
            anchor(leading: leading, paddingLeading: paddingLeading)
        }
    }
    
    func centerY(inView view: UIView, leadingAnchor: NSLayoutXAxisAnchor? = nil, paddingLeading: CGFloat = 0, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let leading = leadingAnchor {
            anchor(leading: leading, paddingLeading: paddingLeading)
        }
    }
    
    func center(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.systemRed.cgColor]
        gradient.locations = [0, 1]
        self.layer.addSublayer(gradient)
        gradient.frame = self.bounds
    }
    
    func NSLayoutActivate(_ objects:[NSLayoutConstraint]) {
        objects.forEach({$0.isActive = true})
    }
    
    func NSLayoutDeactivate(_ objects:[NSLayoutConstraint]) {
        objects.forEach({$0.isActive = false})
    }
}

//MARK: - UIViewController

extension UIViewController {
    
    func animateTableView(_ tableView: UITableView, atIndexPath indexPath: IndexPath, presentingVC: UIViewController? = nil) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: .zero, options: .curveEaseInOut) {
            selectedCell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        } completion: { [weak self] _ in
            self?.present(presentingVC!, animated: true)
        }
        UIView.animate(withDuration: 0.3, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: .zero, options: .curveEaseInOut) {
            selectedCell?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    ///Fetching data from Yelp
    func fetchYelpData(latitude: Double,
                       longitude: Double,
                       category: String,
                       limit: Int,
                       sortBy: String,
                       locale: String,
                       completionHandler: @escaping ([Restaurant]?, Error?) -> Void) {
        
        ///API KEY:
        let apiKey = "EuJUR75BOMjHAH5s4tzKpuioI5pEOf2VIYrNA4byGfWKwda3uh9Ouzwx2Q_XZj48ygDUodrZpHBCcZluPwSAAcn0bNAqDjhdazRcfdl2XeCA7ul07AkJyQDKDI__X3Yx"
        
        ///Create URL:
        let baseURL = "https://api.yelp.com/v3/businesses/search?latitude\(latitude)&longitude=\(longitude)&category\(category)&limit\(limit)&sort_by=\(sortBy)&locale\(locale)"
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
                guard let mainDict = json as? NSDictionary else { return }
                
                //Accessing each business, setting the properties in Restaurant object and appending the object to empty restaurant array
                guard let businesses = mainDict.value(forKey: "businesses") as? [NSDictionary] else { return }
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
    
}

//MARK: - UIImage

extension UIImage {
    
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 35, width: size.width, height: lineWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}

//MARK: - Array

extension Array where Element: Hashable {
    var uniques: Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
