//
//  MockViewPresenter.swift
//  RijksmuseumTests
//
//  Created by Cedrick Gout on 26/05/2023.
//

import XCTest
@testable import Rijksmuseum

class MockViewUpdater<State>: ViewUpdater {
    
    private var stateHandlers: [(State) -> Void]?
    private var completionExpectation: XCTestExpectation?
    
    init(eventProcessor: EventProcessor<State>) {
        if case let .events(handlers, exp) = eventProcessor {
            stateHandlers = handlers
            completionExpectation = exp
        }
    }
    
    func update(state: State) {
        guard let handler = stateHandlers?.removeFirst(),
              let completionExpectation else {
            XCTFail("Expected no (more) states changes but got \(state).")
            return
        }
        
        handler(state)
        if stateHandlers?.isEmpty ?? false {
            completionExpectation.fulfill()
        }
    }
}
