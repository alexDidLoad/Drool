//
//  MapTableView.swift
//  Drool
//
//  Created by Alexander Ha on 1/11/21.
//

import UIKit
import MapKit

private let reuseIdentifier = "MapCell"

protocol MapSearchViewDelegate {
    
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
    
    private var tableView: UITableView!
    
    //MARK: - Properties
    
    enum ExpansionState {
        case NotExpanded
        case Expanded
    }
    
    var mapController: MapVC?
    var expansionState: ExpansionState!
    var delegate: MapSearchViewDelegate?
    var searchResults: [MKMapItem]? {
        didSet {
            tableView.reloadData()
        }
    }
    
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
            if expansionState == .NotExpanded {
                animateSearchView(targetPosition: self.frame.origin.y - 250) { (_) in
                    self.expansionState = .Expanded
                }
            }
        } else if sender.direction == .down {
            if expansionState == .Expanded {
                animateSearchView(targetPosition: self.frame.origin.y + 250) { (_) in
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
        tableView.anchor(top: indicatorView.bottomAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor,
                         paddingTop: 8,
                         paddingBottom: 100)
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
}

//MARK: - UITableViewDelegate and DataSource

extension MapSearchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MapCell
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //TODO: Bring selected row to top and have 'GO' button appear with a heart button
        print(indexPath.row)
    }
    
}
