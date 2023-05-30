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
    private let file: StaticString
    private let line: UInt
    
    init(eventProcessor: EventProcessor<Action>, file: StaticString = #file, line: UInt = #line) {
        if case let .events(handlers, exp) = eventProcessor {
            actionHandlers = handlers
            completionExpectation = exp
        }
        
        self.line = line
        self.file = file
    }
    
    func handle(action: Action) {
        guard let handlers = actionHandlers,
              !handlers.isEmpty,
              let handler = actionHandlers?.removeFirst(),
              let completionExpectation else {
            XCTFail("Expected no (more) actions changes but got \(action).", file: file, line: line)
            return
        }
        
        handler(action)
        if actionHandlers?.isEmpty ?? false {
            completionExpectation.fulfill()
        }
    }
}
