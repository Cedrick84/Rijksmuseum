//
//  ObjectListViewPresenterImpTests.swift
//  RijksmuseumTests
//
//  Created by Cedrick Gout on 26/05/2023.
//

import XCTest
@testable import Rijksmuseum

@MainActor
final class ObjectListViewPresenterImpTests: XCTestCase {

    func test_onProcessEvent_callsViewUpdater() throws {
        let id = UUID().uuidString
        let summary = ArtObjectSummary(id: id, title: "", imageURL: .test)
        let viewModel = ObjectSummaryCellViewModel(id: id, title: "", imageURL: .test)
        
        let mapping: [(event: ObjectListViewPresenterEvent, state: PaginatedViewState<[ObjectSummaryCellViewModel]>)] = [
            (.loading, .loading),
            (.loaded([]), .empty),
            (.partiallyLoaded([summary]), .partiallyLoaded([viewModel])),
            (.loaded([summary]), .loaded([viewModel])),
            (.error(.decoding), .error(APIError.decoding.message))
        ]
        
        mapping.forEach { tuple in
            let viewUpdaterCalledExpectation = expectation(description: "View updater called.")
            let viewUpdaterCompletedExpectation = expectation(description: "View updater completed.")
            
            let viewUpdater = MockViewUpdater<PaginatedViewState<[ObjectSummaryCellViewModel]>>(eventProcessor: .events([{ state in
                guard tuple.state == state else {
                    XCTFail("Expected \(tuple.state) but got \(state).")
                    return
                }
                
                viewUpdaterCalledExpectation.fulfill()
            }], viewUpdaterCompletedExpectation))
            
            let presenter = ObjectListViewPresenterImp(viewUpdater: viewUpdater)
            presenter.process(event: tuple.event)
            
            wait(for: [viewUpdaterCalledExpectation, viewUpdaterCompletedExpectation], timeout: 0.1, enforceOrder: true)
        }
    }
}
