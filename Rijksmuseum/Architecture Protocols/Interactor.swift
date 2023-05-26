//
//  Interactor.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 25/05/2023.
//

import Foundation

protocol Interactor<Action>: ActionListener {
    associatedtype PresenterType: Presenter
    associatedtype RouterType: Router

    var router: RouterType? { get }
    var presenter: PresenterType { get }
}
