//
//  EventProcessor.swift
//  RijksmuseumTests
//
//  Created by Cedrick Gout on 26/05/2023.
//

import XCTest

enum EventProcessor<T> {
    case events([(T) -> Void], XCTestExpectation)
    case none
}
