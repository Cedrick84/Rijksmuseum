//
//  MockViewControllerPresenter.swift
//  RijksmuseumTests
//
//  Created by Cedrick Gout on 26/05/2023.
//

import XCTest
@testable import Rijksmuseum

final class MockViewControllerPresenter: ViewControllerPresenter {
    
    var presentationHandlers: [(UIViewController) -> Void] = []
    var completed: Bool { presentationHandlers.isEmpty }
    
    init(rootViewController: UIViewController) {}
    
    func present(viewController: UIViewController) {
        guard !presentationHandlers.isEmpty else {
            XCTFail("Expected no more view controllers but got \(viewController).")
            return
        }
        
        let handler = presentationHandlers.removeFirst()
        handler(viewController)
    }
}
