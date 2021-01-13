//
//  MapCell.swift
//  Drool
//
//  Created by Alexander Ha on 1/12/21.
//

import UIKit

class MapCell: UITableViewCell {
    
    //MARK: - UIComponents
    
    private lazy var goButton: UIButton = {
        let button = UIButton(type: .system)
        button.setDimensions(height: 50, width: 50)
        button.setImage(UIImage(systemName: "car.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        button.layer.cornerRadius = 5
        button.alpha = 1
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
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    private let closedIndicator: UIView = {
        let view = UIView()
        view.setDimensions(height: 15, width: 15)
        view.layer.cornerRadius = 15 / 2
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.systemRed.withAlphaComponent(0.5)
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
    
    var name: String! = "Test Cell"
    var price: String! = "$$$" {
        didSet {
            priceLabel.text = price
        }
    }
    var isClosed: Bool! = false
    var hasFavorited: Bool! = false
    
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
        print("Handle go here...")
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
    
    private func configureCellUI() {
        selectionStyle = .none
        
        contentView.addSubview(goButton)
        goButton.centerY(inView: self)
        goButton.anchor(trailing: trailingAnchor, paddingTrailing: 16)
        
        contentView.addSubview(favoriteButton)
        favoriteButton.setDimensions(height: 30, width: 40)
        favoriteButton.centerY(inView: self)
        favoriteButton.anchor(trailing: goButton.leadingAnchor, paddingTrailing: 32)
        
        addSubview(priceLabel)
        priceLabel.text = price
        priceLabel.centerY(inView: self)
        priceLabel.anchor(trailing: favoriteButton.leadingAnchor, paddingTrailing: 24)
        
        addSubview(closedIndicator)
        closedIndicator.centerY(inView: self)
        closedIndicator.anchor(trailing: priceLabel.leadingAnchor, paddingTrailing: 24)
        
        addSubview(restaurantLabel)
        restaurantLabel.text = name
        restaurantLabel.centerY(inView: self)
        restaurantLabel.anchor(leading: leadingAnchor,
                               trailing: closedIndicator.leadingAnchor,
                               paddingLeading: 8,
                               paddingTrailing: 8)
        
        
        
        
        
        
    }
    
}
