//
//  MockViewPresenter.swift
//  RijksmuseumTests
//
//  Created by Cedrick Gout on 26/05/2023.
//

import XCTest
@testable import Rijksmuseum

class MockViewRouter<Action>: Router {
    
    private var actionHandlers: [(Action) -> Void]?
    private var completionExpectation: XCTestExpectation?
    
    init(eventProcessor: EventProcessor<Action>) {
        if case let .events(handlers, exp) = eventProcessor {
            actionHandlers = handlers
            completionExpectation = exp
        }
    }
    
    func handle(action: Action) {
        guard let handler = actionHandlers?.removeFirst(),
              let completionExpectation else {
            XCTFail("Expected no (more) actions changes but got \(action).")
            return
        }
        
        handler(action)
        if actionHandlers?.isEmpty ?? false {
            completionExpectation.fulfill()
        }
    }
}
