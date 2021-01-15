//
//  FoodCell.swift
//  Drool
//
//  Created by Alexander Ha on 1/10/21.
//

import UIKit

class FoodCell: UITableViewCell {
    
    //MARK: - UIComponents
    
    let containerView: UIView = {
        let cView = UIView()
        return cView
    }()
    
    let cellImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 15
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .left
        return label
    }()
    
    private let gradientView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 28, width: 366, height: 160))
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor]
        gradient.locations = [0, 0.9, 1]
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
        return view
    }()
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor,
                             leading: leadingAnchor,
                             bottom: bottomAnchor,
                             trailing: trailingAnchor,
                             paddingTop: 12,
                             paddingLeading: 12,
                             paddingBottom: 12,
                             paddingTrailing: 12)
        
        containerView.addSubview(cellImageView)
        cellImageView.addConstraintsToFillView(view: containerView)
        
        cellImageView.addSubview(categoryLabel)
        categoryLabel.layer.zPosition = 1
        categoryLabel.anchor(leading: cellImageView.leadingAnchor,
                             bottom: cellImageView.bottomAnchor,
                             trailing: cellImageView.trailingAnchor,
                             paddingLeading: 8)
        
        cellImageView.addSubview(gradientView)
        cellImageView.bringSubviewToFront(gradientView)
    }
}

