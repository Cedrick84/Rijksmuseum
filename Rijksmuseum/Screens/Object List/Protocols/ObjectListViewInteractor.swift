//
//  ObjectListViewInteractor.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 26/05/2023.
//

import Foundation

enum ObjectListViewAction {
    case requestList
    case openDetails
}

protocol ObjectListViewInteractor: Interactor<ObjectListViewAction> where PresenterType: ObjectListViewPresenter {}
