//
//  ObjectDetailViewModel.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import Foundation

struct ObjectDetailViewModel: Equatable {
    
    let title: String
    let description: String
}

extension ObjectDetailViewModel {
    
    init(_ summary: ArtObject) {
        title = summary.title
        description = summary.description
    }
}
