//
//  FavoritesCell.swift
//  Drool
//
//  Created by Alexander Ha on 1/15/21.
//

import UIKit
import CoreData

class FavoritesCell: UITableViewCell {
    
    //MARK: - UIComponenets
    
    private let containerView: UIView = {
        let cView = UIView()
        cView.backgroundColor = .white
        cView.layer.cornerRadius = 15
        cView.layer.masksToBounds = true
        return cView
    }()
    
    private let restauarantImageView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(height: 150, width: 150)
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 150 / 2
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "RESTAURANT NAME"
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "RATING: "
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "ADDRESS: "
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = "(012)345-6789"
        return label
    }()
    
    lazy var heartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageView?.addConstraintsToFillView(view: button)
        button.tintColor = .systemRed
        button.addTarget(self, action: #selector(handleUnfavorite), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Properties
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var hasFavorited: Bool! = true
    var favoritesVC: FavoritesVC?
    var favorite: Favorite? {
        didSet {
            updateLabels()
        }
    }
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleUnfavorite() {
        removeItems()
    }
    
    //MARK: - Helpers
    
    private func removeItems() {
        guard let itemToUnfavorite = self.favorite else { return }
        favoritesVC = FavoritesVC()
        
        //Delete object
        self.context.delete(itemToUnfavorite)
        //Save the data
        do {
            try self.context.save()
        } catch {
            print("DEBUG: Error in saving context when unfavoriting")
        }
        
        DispatchQueue.main.async {
            self.hasFavorited = false
            self.alpha = 0
            self.favoritesVC?.fetchRestaurants()
        }
    }
    
    private func updateLabels() {
        guard let favorite = self.favorite else { return }
        nameLabel.text = favorite.name
        ratingLabel.text = String(favorite.rating)
        addressLabel.text = favorite.address
        phoneNumberLabel.text = favorite.phoneNumber
        
        let url = URL(string: favorite.imageURL!)
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.restauarantImageView.image = image
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    private func configureUI() {
        selectionStyle = .none
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        addSubview(containerView)
        containerView.fillViewWithPadding(view: self,
                                          paddingTop: 12,
                                          paddingLeading: 20,
                                          paddingBottom: 12,
                                          paddingTrailing: 20)
        
        containerView.addSubview(restauarantImageView)
        restauarantImageView.centerY(inView: self)
        restauarantImageView.anchor(leading: containerView.leadingAnchor, paddingLeading: 12)
        
        containerView.addSubview(nameLabel)
        nameLabel.anchor(top: restauarantImageView.topAnchor,
                         leading: restauarantImageView.trailingAnchor,
                         trailing: containerView.trailingAnchor,
                         paddingTop: 2,
                         paddingLeading: 10,
                         paddingTrailing: 10)
        
        containerView.addSubview(ratingLabel)
        ratingLabel.anchor(top: nameLabel.bottomAnchor,
                           leading: nameLabel.leadingAnchor,
                           trailing: nameLabel.trailingAnchor,
                           paddingTop: 18)
        
        containerView.addSubview(addressLabel)
        addressLabel.anchor(top: ratingLabel.bottomAnchor,
                            leading: nameLabel.leadingAnchor,
                            trailing: nameLabel.trailingAnchor,
                            paddingTop: 18)
        
        containerView.addSubview(phoneNumberLabel)
        phoneNumberLabel.anchor(top: addressLabel.bottomAnchor,
                                leading: nameLabel.leadingAnchor,
                                trailing: nameLabel.trailingAnchor,
                                paddingTop: 18)
        
        contentView.addSubview(heartButton)
        heartButton.anchor(bottom: containerView.bottomAnchor,
                           trailing: containerView.trailingAnchor,
                           paddingBottom: 10,
                           paddingTrailing: 10)
    }
}
