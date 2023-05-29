//
//  MockObjectListViewWorker.swift
//  RijksmuseumTests
//
//  Created by Cedrick Gout on 26/05/2023.
//

import XCTest
@testable import Rijksmuseum

class MockObjectListViewWorker: ObjectListViewWorker {
    
    var onLoadListItems: (() -> Void)?
    var loadListItemsResult: Result<[ArtObjectSummary], Error>?
    
    func loadListItems() async throws -> [ArtObjectSummary] {
        guard let loadListItemsResult else {
            XCTFail("\(#function) called without having a response defined.")
            return []
        }
        
        onLoadListItems?()
        
        switch loadListItemsResult {
        case .success(let items):
            return items
        case .failure(let error):
            throw error
        }
    }
}
