//
//  LoadingFooterView.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import UIKit

class LoadingFooterView: UICollectionReusableView {
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(indicator)
        
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func startAnimating() {
        indicator.startAnimating()
    }
    
    func stopAnimating() {
        indicator.stopAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
}
