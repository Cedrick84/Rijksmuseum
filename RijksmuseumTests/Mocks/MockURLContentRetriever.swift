//
//  MockURLContentRetriever.swift
//  RijksmuseumTests
//
//  Created by Cedrick Gout on 29/05/2023.
//

import XCTest
@testable import Rijksmuseum

class MockURLContentRetriever: URLContentRetriever {
    
    var response: Result<(Data, URLResponse), Error>?
    var onDataFromURL: ((URL) -> Void)?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        guard let response else {
            XCTFail("\(#function) called without having a response defined.")
            return (Data(), .init())
        }
        
        onDataFromURL?(url)
        
        switch response {
        case .success(let tuple):
            return tuple
        case .failure(let error):
            throw error
        }
    }
}
