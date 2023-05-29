//
//  ObjectListViewWorker.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 26/05/2023.
//

import Foundation

protocol ObjectListViewWorker {
    func loadListItems() async throws -> [ArtObjectSummary]
}
