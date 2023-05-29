//
//  ArtObjectSummary.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 26/05/2023.
//

import Foundation

struct ArtObjectSummary: Equatable, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "objectNumber"
        case title
    }
    
    let id: String
    let title: String
}
