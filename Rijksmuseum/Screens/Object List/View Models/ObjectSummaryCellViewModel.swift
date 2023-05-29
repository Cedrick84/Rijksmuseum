//
//  ObjectSummaryCellViewModel.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 26/05/2023.
//

import Foundation

struct ObjectSummaryCellViewModel: Equatable {
    
    let id: String
    let title: String
    let imageURL: URL
}

extension ObjectSummaryCellViewModel {
    
    init(_ summary: ArtObjectSummary) {
        id = summary.id
        title = summary.title
        imageURL = summary.imageURL
    }
}
