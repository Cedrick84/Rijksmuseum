//
//  ActionListener.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 25/05/2023.
//

import Foundation

protocol ActionListener<Action> {
    associatedtype Action

    @MainActor
    func handle(action: Action)
}
