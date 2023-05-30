//
//  MockViewPresenter.swift
//  RijksmuseumTests
//
//  Created by Cedrick Gout on 26/05/2023.
//

import XCTest
@testable import Rijksmuseum

class MockViewPresenter<Event, State>: Presenter {
    
    private var eventHandlers: [(Event) -> Void]?
    private var completionExpectation: XCTestExpectation?
    private let file: StaticString
    private let line: UInt
    
    var viewUpdater: MockViewUpdater<State>?
    
    init(eventProcessor: EventProcessor<Event>, viewUpdater: MockViewUpdater<State>? = nil, file: StaticString = #file, line: UInt = #line) {
        if case let .events(handlers, exp) = eventProcessor {
            eventHandlers = handlers
            completionExpectation = exp
        }
        
        self.line = line
        self.file = file
    }
    
    func process(event: Event) {
        guard let handlers = eventHandlers,
              !handlers.isEmpty,
              let handler = eventHandlers?.removeFirst(),
              let completionExpectation else {
            XCTFail("Expected no (more) events changes but got \(event).", file: file, line: line)
            return
        }
        
        handler(event)
        if eventHandlers?.isEmpty ?? false {
            completionExpectation.fulfill()
        }
    }
}
