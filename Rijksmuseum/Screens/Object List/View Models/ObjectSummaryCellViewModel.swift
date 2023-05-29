//
//  ObjectSummaryCellViewModel.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 26/05/2023.
//

import Foundation

struct ObjectSummaryCellViewModel: Equatable {
    let title: String
}

extension ObjectSummaryCellViewModel {
    
    init(_ summary: ArtObjectSummary) {
        title = summary.title
    }
}
