//
//  ObjectListViewRouterImpTests.swift
//  RijksmuseumTests
//
//  Created by Cedrick Gout on 26/05/2023.
//

import XCTest
@testable import Rijksmuseum

@MainActor
final class ObjectListViewRouterImpTests: XCTestCase {

    func test_onProcessEvent_callsViewUpdater() throws {
        let presentedExpectation = expectation(description: "View controller presented.")

        let router = ObjectListViewRouterImp<MockViewControllerPresenter>()
        let vcPresenter = router.setup()
        vcPresenter.presentationHandlers = [{ vc in
            // TODO: Check actual VC
            XCTAssertEqual(vc.view.backgroundColor, .red)
            
            presentedExpectation.fulfill()
        }]
        
        router.handle(action: .openDetails)
        
        wait(for: [presentedExpectation], timeout: 0.1)
        XCTAssertTrue(vcPresenter.completed)
    }
}
