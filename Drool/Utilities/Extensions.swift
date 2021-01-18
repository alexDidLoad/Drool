//
//  Extensions.swift
//  Drool
//
//  Created by Alexander Ha on 1/9/21.
//

import UIKit
import MapKit

//MARK: - UIView

extension UIView {
    
    func addConstraintsToFillView(view: UIView) {
        self.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingTop: 0, paddingLeading: 0, paddingBottom: 0, paddingTrailing: 0)
    }
    
    func fillViewWithPadding(view: UIView, paddingTop top: CGFloat, paddingLeading lead: CGFloat, paddingBottom bottom: CGFloat, paddingTrailing trailing: CGFloat) {
        self.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, paddingTop: top, paddingLeading: lead, paddingBottom: bottom, paddingTrailing: trailing)
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
    
    func getMapItemPhoneNumber(_ item: MKMapItem) -> String {
        let unwantedChars: Set<Character> = ["(", ")", "-"]
        var mapNumber = item.phoneNumber?.replacingOccurrences(of: " ", with: "")
        mapNumber?.removeAll(where: {unwantedChars.contains($0)})
        guard let newNumber = mapNumber else { return "" }
        return newNumber
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
