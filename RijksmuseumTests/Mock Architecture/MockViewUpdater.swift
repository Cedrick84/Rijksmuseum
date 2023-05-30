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
    private let file: StaticString
    private let line: UInt
    
    init(eventProcessor: EventProcessor<State>, file: StaticString = #file, line: UInt = #line) {
        if case let .events(handlers, exp) = eventProcessor {
            stateHandlers = handlers
            completionExpectation = exp
        }
        
        self.line = line
        self.file = file
    }
    
    func update(state: State) {
        guard let handlers = stateHandlers,
              !handlers.isEmpty,
              let handler = stateHandlers?.removeFirst(),
              let completionExpectation else {
            XCTFail("Expected no (more) states changes but got \(state).", file: file, line: line)
            return
        }
        
        handler(state)
        if stateHandlers?.isEmpty ?? false {
            completionExpectation.fulfill()
        }
    }
}
