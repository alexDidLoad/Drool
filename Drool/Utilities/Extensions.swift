//
//  Extensions.swift
//  Drool
//
//  Created by Alexander Ha on 1/9/21.
//

import UIKit

extension UIView {
    
    //MARK: - Anchors
    
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
}

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
