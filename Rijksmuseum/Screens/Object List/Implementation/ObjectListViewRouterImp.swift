//
//  ObjectListViewRouterImp.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 26/05/2023.
//

import UIKit

final class ObjectListViewRouterImp<VCPresenter: ViewControllerPresenter>: ObjectListViewRouter {
    
    private weak var viewControllerPresenter: VCPresenter?
    
    func setup() -> VCPresenter {
        let viewController = ObjectListViewController()
        let presenter = ObjectListViewPresenterImp(viewUpdater: viewController)
        let interactor = ObjectListViewInteractorImp(router: self, presenter: presenter)
        viewController.actionListener = interactor
        
        let viewControllerPresenter = VCPresenter(rootViewController: viewController)
        self.viewControllerPresenter = viewControllerPresenter
        
        return viewControllerPresenter
    }
    
    func handle(action: ObjectListViewRouterAction) {
        switch action {
        case .openDetails(let id):
            guard let viewControllerPresenter else { return }
            ObjectDetailsViewRouterImp(viewControllerPresenter: viewControllerPresenter, objectID: id).present()
        }
    }
}
