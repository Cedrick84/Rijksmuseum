//
//  ObjectDetailsViewInteractor.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import Foundation

enum ObjectDetailsViewAction {
    case requestDetails
}

protocol ObjectDetailsViewInteractor: Interactor<ObjectDetailsViewAction> where PresenterType: ObjectDetailsViewPresenter {}
