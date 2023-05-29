//
//  CollectionListResponse.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import Foundation

struct CollectionListResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case count
        case objectSummaries = "artObjects"
    }
    
    let count: Int
    let objectSummaries: [ArtObjectSummary]
}
