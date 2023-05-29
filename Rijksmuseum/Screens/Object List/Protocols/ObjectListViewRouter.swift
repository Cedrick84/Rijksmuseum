//
//  ObjectListViewRouter.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 26/05/2023.
//

import Foundation

enum ObjectListViewRouterAction {
    case openDetails(id: String)
}

protocol ObjectListViewRouter: Router<ObjectListViewRouterAction> {}
