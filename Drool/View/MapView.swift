//
//  MapTableView.swift
//  Drool
//
//  Created by Alexander Ha on 1/11/21.
//

import UIKit
import MapKit

private let reuseIdentifier = "SearchCell"

protocol MapViewDelegate {
    
}

class MapView: UIView {
    
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
        case PartiallyExpanded
    }
    
    var mapController: MapVC?
    var expansionState: ExpansionState!
    var delegate: MapViewDelegate?
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        expansionState = .PartiallyExpanded
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        
    }
    
}
