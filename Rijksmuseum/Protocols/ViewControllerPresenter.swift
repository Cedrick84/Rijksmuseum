//
//  ViewControllerPresenter.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 26/05/2023.
//

import UIKit

public protocol ViewControllerPresenter: AnyObject {
    
    func present(viewController: UIViewController)
    
    init(rootViewController: UIViewController)
}

extension UINavigationController: ViewControllerPresenter {
    
    public func present(viewController: UIViewController) {
        pushViewController(viewController, animated: true)
    }
}
