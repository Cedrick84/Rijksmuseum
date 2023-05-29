//
//  ObjectDetailsViewRouterImp.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import UIKit

final class ObjectDetailsViewRouterImp<VCPresenter: ViewControllerPresenter>: ObjectDetailsViewRouter {
    
    private weak var viewControllerPresenter: VCPresenter?
    private let objectID: String
    
    init(viewControllerPresenter: VCPresenter, objectID: String) {
        self.viewControllerPresenter = viewControllerPresenter
        self.objectID = objectID
    }
    
    func present() {
        let viewController = ObjectDetailsViewController()
        let presenter = ObjectDetailsViewPresenterImp(viewUpdater: viewController)
        let interactor = ObjectDetailsViewInteractorImp(objectID: objectID, router: self, presenter: presenter)
        viewController.actionListener = interactor

        viewControllerPresenter?.present(viewController: viewController)
    }
    
    func handle(action: ObjectDetailsViewRouterAction) {}
}
