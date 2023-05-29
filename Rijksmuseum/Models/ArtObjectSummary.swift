//
//  ArtObjectSummary.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 26/05/2023.
//

import Foundation

struct ArtObjectSummary: Equatable, Decodable {
    
    let id: String
    let title: String
    let imageURL: URL
    
    enum CodingKeys: String, CodingKey {
        case id = "objectNumber"
        case title
        case webImage
    }
    
    enum WebImageKeys: CodingKey {
        case url
    }
    
    init(id: String, title: String, imageURL: URL) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
    }
    
    init(from decoder: Decoder) throws {
        let outerContainer = try decoder.container(keyedBy: CodingKeys.self)
        let webImageContainer = try outerContainer.nestedContainer(keyedBy: WebImageKeys.self, forKey: .webImage)
        
        id = try outerContainer.decode(String.self, forKey: .id)
        title = try outerContainer.decode(String.self, forKey: .title)
        imageURL = try webImageContainer.decode(URL.self, forKey: .url)
    }
}
