//
//  MockJSONDecoder.swift
//  RijksmuseumTests
//
//  Created by Cedrick Gout on 29/05/2023.
//

import XCTest
@testable import Rijksmuseum

struct MockJSONDecoder<T: Decodable>: JSONDecoderProtocol {
    
    private let result: Result<T, Error>
    
    init(result: Result<T, Error>) {
        self.result = result
    }
    
    func decode<T>(_ type: T.Type, from data: Data, keyPath: String, keyPathSeparator separator: String) throws -> T where T: Decodable {
        try decode(type, from: data)
    }
    
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        switch result {
        case .success(let decoded):
            return decoded as! T
        case .failure(let error):
            throw error
        }
    }
}
