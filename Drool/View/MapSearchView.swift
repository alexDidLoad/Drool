//
//  MapTableView.swift
//  Drool
//
//  Created by Alexander Ha on 1/11/21.
//

import UIKit
import MapKit

let reuseIdentifier = "MapCell"

protocol MapSearchViewDelegate {
    func didSelectAnnotation(withMapItem mapItem: MKMapItem)
    func addAnnotations(forRestaurants: [Restaurant])
    func refresh()
}

class MapSearchView: UIView {
    
    //MARK: - UIComponents
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 5
        view.alpha = 0.8
        return view
    }()
    
    private var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(handlePullRefresh), for: .valueChanged)
        return refresh
    }()
    
    private var mapTableView: UITableView!
    
    //MARK: - Properties
    
    enum ExpansionState {
        case NotExpanded
        case Expanded
    }
    
    var restaurants: [Restaurant]! {
        didSet {
            DispatchQueue.main.async {
                self.mapTableView.reloadData()
            }
        }
    }
    
    private var hasRefreshed: Bool = false
    var mapController: MapVC?
    var expansionState: ExpansionState!
    var delegate: MapSearchViewDelegate?
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleSwipeGesture(sender: UISwipeGestureRecognizer) {
        if sender.direction == .up && expansionState == .NotExpanded {
            animateSearchView(targetPosition: self.frame.origin.y - 225) { (_) in
                self.expansionState = .Expanded
            }
        } else if sender.direction == .down && expansionState == .Expanded {
            animateSearchView(targetPosition: self.frame.origin.y + 225) { (_) in
                self.expansionState = .NotExpanded
            }
        }
    }
    
    @objc func handlePullRefresh() {
        hasRefreshed = true
        restaurants?.removeAll()
        delegate?.refresh()
        DispatchQueue.main.async {
            self.mapTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        backgroundColor = .white
        layer.cornerRadius = 14
        layer.shadowRadius = 10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -5)
        layer.shadowOpacity = 0.3
        
        addSubview(indicatorView)
        indicatorView.anchor(top: topAnchor, paddingTop: 8, height: 8, width: 80)
        indicatorView.centerX(inView: self)
        
        configureTableView()
        configureGestureRecognizer()
    }
    
    private func configureTableView() {
        mapTableView = UITableView()
        mapTableView.rowHeight = 72
        mapTableView.delegate = self
        mapTableView.dataSource = self
        mapTableView.register(MapCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        addSubview(mapTableView)
        mapTableView.setHeight(height: 275)
        mapTableView.anchor(top: indicatorView.bottomAnchor,
                         leading: leadingAnchor,
                         trailing: trailingAnchor,
                         paddingTop: 8)
        
        mapTableView.addSubview(refreshControl)
    }
    
    private func configureGestureRecognizer() {
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeUp.direction = .up
        addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
    
    private func animateSearchView(targetPosition: CGFloat, completion: @escaping(Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            //changes y position of view
            self.frame.origin.y = targetPosition
        }, completion: completion)
    }
    
    private func didSelectRestaurant(_ restaurants: [Restaurant], selectedRestaurant: Restaurant, atIndexPath indexPath: IndexPath) -> [Restaurant] {
        var restaurants = restaurants
        restaurants.remove(at: indexPath.row)
        restaurants.insert(selectedRestaurant, at: 0)
        restaurants.removeSubrange(1..<restaurants.count)
        return restaurants
    }
}

//MARK: - UITableViewDelegate and DataSource

extension MapSearchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let restaurants = restaurants else { return 0 }
        delegate?.addAnnotations(forRestaurants: restaurants)
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MapCell
        if let mapController = mapController {
            cell.delegate = mapController
        }
        if let restaurants = restaurants {
            cell.restaurant = restaurants[indexPath.row]
        }
        if hasRefreshed {
            cell.removeButton()
            hasRefreshed = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMapItem = MKMapItem()
        let selectedRestaurant = restaurants[indexPath.row]
        selectedMapItem.name = selectedRestaurant.name
        
        delegate?.didSelectAnnotation(withMapItem: selectedMapItem)
        self.restaurants = didSelectRestaurant(restaurants, selectedRestaurant: selectedRestaurant, atIndexPath: indexPath)
        
        let firstIndexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: firstIndexPath) as? MapCell
        
        cell?.animateButtonIn()
    }
}
