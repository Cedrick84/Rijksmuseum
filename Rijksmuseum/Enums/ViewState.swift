//
//  ViewState.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 25/05/2023.
//

import Foundation

enum ViewState<T: Equatable>: Equatable {
    case empty
    case loading
    case loaded(T)
    case error(String)
}
