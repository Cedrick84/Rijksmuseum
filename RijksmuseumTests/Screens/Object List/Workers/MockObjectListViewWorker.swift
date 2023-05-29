//
//  MockObjectListViewWorker.swift
//  RijksmuseumTests
//
//  Created by Cedrick Gout on 26/05/2023.
//

import XCTest
@testable import Rijksmuseum

class MockObjectListViewWorker: ObjectListViewWorker {
    
    var onLoadListItems: ((Int, Int) -> Void)?
    var loadListItemsResult: Result<[ArtObjectSummary], Error>?
    
    func loadListItems(for page: Int, with size: Int) async throws -> [ArtObjectSummary] {
        guard let loadListItemsResult else {
            XCTFail("\(#function) called without having a response defined.")
            return []
        }
        
        onLoadListItems?(page, size)
        
        switch loadListItemsResult {
        case .success(let items):
            return items
        case .failure(let error):
            throw error
        }
    }
}
