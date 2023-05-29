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
        let errorDescription = UUID().uuidString
        let error = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: errorDescription])
        let mapping: [(event: ObjectListViewPresenterEvent, state: ViewState<[ObjectSummaryCellViewModel]>)] = [
            (.loading, .loading),
            (.loaded([]), .empty),
            (.loaded([.init()]), .loaded([.init()])),
            (.error(error), .error(errorDescription))
        ]
        
        mapping.forEach { tuple in
            let viewUpdaterCalledExpectation = expectation(description: "View updater called.")
            let viewUpdaterCompletedExpectation = expectation(description: "View updater completed.")
            
            let viewUpdater = MockViewUpdater<ViewState<[ObjectSummaryCellViewModel]>>(eventProcessor: .events([{ state in
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
