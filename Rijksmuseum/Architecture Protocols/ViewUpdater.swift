//
//  ViewUpdater.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 25/05/2023.
//

import Foundation

protocol ViewUpdater<State>: AnyObject {
    associatedtype State
    
    @MainActor
    func update(state: State)
}
