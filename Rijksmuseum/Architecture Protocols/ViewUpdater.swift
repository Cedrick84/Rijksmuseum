//
//  ViewUpdater.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 25/05/2023.
//

import Foundation

protocol ViewUpdater<State>: AnyObject {
    associatedtype State
    
    func update(state: State)
}
