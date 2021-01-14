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
    
    var tableView: UITableView!
    
    //MARK: - Properties
    
    enum ExpansionState {
        case NotExpanded
        case Expanded
    }
    
    var restaurants: [Restaurant]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var mapController: MapVC?
    var expansionState: ExpansionState!
    var delegate: MapSearchViewDelegate?
    var searchResults: [MKMapItem]? 
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        expansionState = .NotExpanded
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleSwipeGesture(sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            tableView.reloadData()
            if expansionState == .NotExpanded {
                animateSearchView(targetPosition: self.frame.origin.y - 225) { (_) in
                    self.expansionState = .Expanded
                }
            }
        } else if sender.direction == .down {
            if expansionState == .Expanded {
                animateSearchView(targetPosition: self.frame.origin.y + 225) { (_) in
                    self.expansionState = .NotExpanded
                }
            }
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
        tableView = UITableView()
        tableView.rowHeight = 72
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MapCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        addSubview(tableView)
        tableView.setHeight(height: 275)
        tableView.anchor(top: indicatorView.bottomAnchor,
                         leading: leadingAnchor,
                         trailing: trailingAnchor,
                         paddingTop: 8)
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
    
    private func didSelectMapItem(withMapItems items: [MKMapItem], selectedMapItem: MKMapItem, atIndexPath indexPath: IndexPath) -> [MKMapItem] {
        var items = items
        items.remove(at: indexPath.row)
        items.insert(selectedMapItem, at: 0)
        items.removeSubrange(1..<items.count)
        return items
    }
}

//MARK: - UITableViewDelegate and DataSource

extension MapSearchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let restaurants = restaurants else { return 0 }
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MapCell
        if let mapController = mapController {
            cell.delegate = mapController
        }
        if let searchResults = searchResults {
            cell.mapItem = searchResults[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let searchResults = searchResults else { return }
        let selectedMapItem = searchResults[indexPath.row]
        
        delegate?.didSelectAnnotation(withMapItem: selectedMapItem)
        self.searchResults = didSelectMapItem(withMapItems: searchResults, selectedMapItem: selectedMapItem, atIndexPath: indexPath)
        
        let firstIndexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: firstIndexPath) as? MapCell
        cell?.animateButtonIn()
       
    }
    
}
