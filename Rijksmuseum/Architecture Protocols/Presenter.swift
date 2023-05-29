//
//  Presenter.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 25/05/2023.
//

import Foundation

protocol Presenter<Event> {
    associatedtype Event
    associatedtype ViewUpdaterType: ViewUpdater

    var viewUpdater: ViewUpdaterType? { get }
    
    @MainActor
    func process(event: Event)
}
