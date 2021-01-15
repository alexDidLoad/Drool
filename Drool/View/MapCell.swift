//
//  MapCell.swift
//  Drool
//
//  Created by Alexander Ha on 1/12/21.
//

import UIKit
import MapKit

protocol MapCellDelegate {
    func getDirections(forMapItem mapItem: MKMapItem) 
}

class MapCell: UITableViewCell {
    
    //MARK: - UIComponents
    
    private lazy var goButton: UIButton = {
        let button = UIButton(type: .system)
        button.setDimensions(height: 50, width: 50)
        button.setImage(UIImage(systemName: "car.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        button.layer.cornerRadius = 5
        button.alpha = 0
        button.addTarget(self, action: #selector(handleGo), for: .touchUpInside)
        return button
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageView?.addConstraintsToFillView(view: button)
        button.tintColor = UIColor.lightGray.withAlphaComponent(0.6)
        button.addTarget(self, action: #selector(handleFavorite), for: .touchUpInside)
        return button
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let closedIndicator: UIView = {
        let view = UIView()
        view.setDimensions(height: 15, width: 15)
        view.layer.cornerRadius = 15 / 2
        view.layer.masksToBounds = true
        return view
    }()
    
    private let restaurantLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Properties

    var delegate: MapCellDelegate?
    
    var isClosed: Bool! = false {
        didSet {
            if isClosed {
                closedIndicator.backgroundColor = UIColor.systemRed.withAlphaComponent(0.5)
            } else {
                closedIndicator.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.5)
            }
        }
    }
    var hasFavorited: Bool! = false
//    var mapItem: MKMapItem? {
//        didSet {
//            configureCellLabel()
//        }
//    }
    
    var restaurant: Restaurant? {
        didSet {
            configureCellLabel()
        }
    }
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleGo() {
//        if let mapItem = mapItem {
//            delegate?.getDirections(forMapItem: mapItem)
//        }
        
    }
    
    @objc func handleFavorite() {
        print("Handle favorite here...")
        hasFavorited.toggle()
        if hasFavorited {
            favoriteButton.tintColor = .systemRed
        } else {
            favoriteButton.tintColor = UIColor.lightGray.withAlphaComponent(0.6)
        }
    }
    
    //MARK: - Helpers
    
    func animateButtonIn() {
        goButton.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        UIView.animate(withDuration: 0.9, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.goButton.transform = .identity
            self.goButton.alpha = 1
            self.favoriteButton.alpha = 1
        }
    }
    
    func removeButton() {
        self.goButton.alpha = 0
    }
    
    private func configureCellLabel() {
        restaurantLabel.text = restaurant?.name ?? "Not Available"
        isClosed = restaurant?.is_closed ?? false
        priceLabel.text = restaurant?.price ?? "-"
    }
    
    private func configureCellUI() {
        selectionStyle = .none
        
        contentView.addSubview(goButton)
        goButton.centerY(inView: self)
        goButton.anchor(trailing: trailingAnchor, paddingTrailing: 16)
        
        contentView.addSubview(favoriteButton)
        favoriteButton.setDimensions(height: 30, width: 40)
        favoriteButton.centerY(inView: self)
        favoriteButton.anchor(trailing: goButton.leadingAnchor, paddingTrailing: 32)
        
        priceLabel.setWidth(width: 50)
        addSubview(priceLabel)
        priceLabel.centerY(inView: self)
        priceLabel.anchor(trailing: favoriteButton.leadingAnchor, paddingTrailing: 6)
        
        addSubview(closedIndicator)
        closedIndicator.centerY(inView: self)
        closedIndicator.centerX(inView: self, constant: -10)
        
        addSubview(restaurantLabel)
        restaurantLabel.centerY(inView: self)
        restaurantLabel.anchor(leading: leadingAnchor,
                               trailing: closedIndicator.leadingAnchor,
                               paddingLeading: 8,
                               paddingTrailing: 8)
    }
    
}
