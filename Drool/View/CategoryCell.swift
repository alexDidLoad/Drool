//
//  CategoryCell.swift
//  Drool
//
//  Created by Alexander Ha on 1/9/21.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    //MARK: - UIComponents
    
    let cellImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        return label
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
        backgroundColor = .white
        selectionStyle = .none
        
        addSubview(cellImageView)
        cellImageView.addConstraintsToFillView(view: self)
    }
    
}
