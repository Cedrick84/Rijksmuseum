//
//  ObjectDetailsViewWorker.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import Foundation

protocol ObjectDetailsViewWorker {
    func loadDetails(with id: String) async throws -> ArtObject
}
