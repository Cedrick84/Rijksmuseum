//
//  APIClientImpTests.swift
//  RijksmuseumTests
//
//  Created by Cedrick Gout on 29/05/2023.
//

import XCTest
@testable import Rijksmuseum

final class APIClientImpTests: XCTestCase {

    func testEndpoints_generateCorrectURLandKeyPath() throws {
        let listEndpoint = APIClientImp.Endpoint.list(page: 1, size: 1)
        XCTAssertEqual(listEndpoint.decodingKeyPath, "artObjects")
        XCTAssertEqual(listEndpoint.url.absoluteString, "https://www.rijksmuseum.nl/api/nl/collection?key=0fiuZFh4&involvedMaker=Rembrandt+van+Rijn&imgonly=True&p=1&ps=1")
        
        let detailEndpoint = APIClientImp.Endpoint.details(id: "1")
        XCTAssertEqual(detailEndpoint.decodingKeyPath, "artObject")
        XCTAssertEqual(detailEndpoint.url.absoluteString, "https://www.rijksmuseum.nl/api/nl/collection/1?key=0fiuZFh4")
    }
    
    func testGetObjectSummariesOnSuccess_returnsItems() async throws {
        let responseData = Data.from(jsonFile: "list-response")
        
        let contentRetriever = MockURLContentRetriever()
        contentRetriever.response = .success((responseData, .init()))
        
        let client = APIClientImp(urlContentRetriever: contentRetriever, jsonDecoder: JSONDecoder())
        let items = try await client.getObjectSummaries(for: 1, with: 1)
        XCTAssertEqual(items.count, 1)
    }
    
    func testGetObjectSummariesOnNetworkFailure_returnsNetworkError() async throws {
        let contentRetriever = MockURLContentRetriever()
        contentRetriever.response = .failure(NSError(domain: "", code: 1))
        
        let client = APIClientImp(urlContentRetriever: contentRetriever, jsonDecoder: JSONDecoder())
        let errorExpectation = expectation(description: "Throws network error.")
        
        do {
            _ = try await client.getObjectSummaries(for: 1, with: 1)
        } catch {
            guard case APIError.network = error else {
                XCTFail("Expected a network error but got \(error).")
                return
            }
            
            errorExpectation.fulfill()
        }
        
        await fulfillment(of: [errorExpectation], timeout: 0.1)
    }
    
    func testGetObjectSummariesOnDecodingFailure_returnsDecodingError() async throws {
        let contentRetriever = MockURLContentRetriever()
        contentRetriever.response = .success((.init(), .init()))
        
        let jsonDecoder = MockJSONDecoder<[ArtObjectSummary]>(result: .failure(NSError(domain: "", code: 1)))
        let client = APIClientImp(urlContentRetriever: contentRetriever, jsonDecoder: JSONDecoder())
        let errorExpectation = expectation(description: "Throws network error.")
        
        do {
            _ = try await client.getObjectSummaries(for: 1, with: 1)
        } catch {
            guard case APIError.decoding = error else {
                XCTFail("Expected a decoding error but got \(error).")
                return
            }
            
            errorExpectation.fulfill()
        }
        
        await fulfillment(of: [errorExpectation], timeout: 0.1)
    }
}
