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
    
    var viewUpdater: MockViewUpdater<State>?
    
    init(eventProcessor: EventProcessor<Event>, viewUpdater: MockViewUpdater<State>? = nil) {
        if case let .events(handlers, exp) = eventProcessor {
            eventHandlers = handlers
            completionExpectation = exp
        }
    }
    
    func process(event: Event) {
        guard let handler = eventHandlers?.removeFirst(),
              let completionExpectation else {
            XCTFail("Expected no (more) events changes but got \(event).")
            return
        }
        
        handler(event)
        if eventHandlers?.isEmpty ?? false {
            completionExpectation.fulfill()
        }
    }
}
