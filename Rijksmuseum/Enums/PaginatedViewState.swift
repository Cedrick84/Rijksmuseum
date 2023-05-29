//
//  PaginatedViewState.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import Foundation

enum PaginatedViewState<T: Equatable>: Equatable {
    case empty
    case loading
    case partiallyLoaded(T)
    case loaded(T)
    case error(String)
}

extension PaginatedViewState {
    var items: T? {
        switch self {
        case .partiallyLoaded(let items):
            return items
        case .loaded(let items):
            return items
        default: return nil
        }
    }
}
