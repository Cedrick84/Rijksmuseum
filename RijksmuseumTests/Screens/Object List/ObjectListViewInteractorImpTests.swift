//
//  ObjectListViewInteractorImpTests.swift
//  RijksmuseumTests
//
//  Created by Cedrick Gout on 26/05/2023.
//

import XCTest
@testable import Rijksmuseum

@MainActor
final class ObjectListViewInteractorImpTests: XCTestCase {
    
    func test_onRequestList_executesWorkerAndUpdatesPresenter() async throws {
        
        let startLoadingExpectation = expectation(description: "Loading event sent.")
        let workerCalledExpectation = expectation(description: "Worker called.")
        let loadedExpectation = expectation(description: "Loaded event sent.")
        let presenterCompletedExpectation = expectation(description: "Presented completed.")
        
        let workerResponse: [ArtObjectSummary] = []
        let router = MockViewRouter<ObjectListViewRouterAction>(eventProcessor: .none)
        let presenter = MockViewPresenter<ObjectListViewPresenterEvent, PaginatedViewState<[ObjectSummaryCellViewModel]>>(eventProcessor:
                .events([{ event in
                    guard case .loading = event else {
                        XCTFail("Expected loading event but got \(event).")
                        return
                    }
                    
                    startLoadingExpectation.fulfill()
                }, { event in
                    guard case .loaded(let items) = event else {
                        XCTFail("Expected loaded event but got \(event).")
                        return
                    }
                    
                    XCTAssertEqual(items, workerResponse)
                    loadedExpectation.fulfill()
                }], presenterCompletedExpectation))
        
        let worker = MockObjectListViewWorker()
        worker.loadListItemsResult = .success(workerResponse)
        worker.onLoadListItems = {
            workerCalledExpectation.fulfill()
        }
        
        let interactor = ObjectListViewInteractorImp(router: router, presenter: presenter, worker: worker)
        await MainActor.run {
            interactor.handle(action: .requestList)
        }
        
        await fulfillment(of: [startLoadingExpectation,
                               workerCalledExpectation,
                               loadedExpectation,
                               presenterCompletedExpectation], timeout: 0.1, enforceOrder: true)
    }
    
    func test_onRequestListWithError_executesWorkerAndUpdatesPresenter() throws {
        let errorDescription = UUID().uuidString
        let expectedError = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: errorDescription])
        
        let startLoadingExpectation = expectation(description: "Loading event sent.")
        let workerCalledExpectation = expectation(description: "Worker called.")
        let errorExpectation = expectation(description: "Error event sent.")
        let presenterCompletedExpectation = expectation(description: "Presented completed.")
        
        let router = MockViewRouter<ObjectListViewRouterAction>(eventProcessor: .none)
        let presenter = MockViewPresenter<ObjectListViewPresenterEvent, PaginatedViewState<[ObjectSummaryCellViewModel]>>(eventProcessor:
                .events([{ event in
                    guard case .loading = event else {
                        XCTFail("Expected loading event but got \(event).")
                        return
                    }
                    
                    startLoadingExpectation.fulfill()
                }, { event in
                    guard case .error(let error) = event else {
                        XCTFail("Expected error event but got \(event).")
                        return
                    }
                    
                    XCTAssertEqual(expectedError, error as NSError)
                    errorExpectation.fulfill()
                }], presenterCompletedExpectation))
        
        let worker = MockObjectListViewWorker()
        worker.loadListItemsResult = .failure(expectedError)
        worker.onLoadListItems = {
            workerCalledExpectation.fulfill()
        }
        
        let interactor = ObjectListViewInteractorImp(router: router, presenter: presenter, worker: worker)
        interactor.handle(action: .requestList)
        
        wait(for: [startLoadingExpectation,
                   workerCalledExpectation,
                   errorExpectation,
                   presenterCompletedExpectation], timeout: 0.1, enforceOrder: true)
    }
    
    func test_onRequestDetails_callsRouter() throws {
        
        let routerCalledExpectation = expectation(description: "Router called.")
        let routerCompletedExpectation = expectation(description: "Router completed.")
        
        let router = MockViewRouter<ObjectListViewRouterAction>(eventProcessor: .events([{ action in
            guard case .openDetails = action else {
                XCTFail("Expected openDetails event but got \(action).")
                return
            }
            
            routerCalledExpectation.fulfill()
        }], routerCompletedExpectation))
        
        let presenter = MockViewPresenter<ObjectListViewPresenterEvent, PaginatedViewState<[ObjectSummaryCellViewModel]>>(eventProcessor: .none)
        let worker = MockObjectListViewWorker()
        
        let interactor = ObjectListViewInteractorImp(router: router, presenter: presenter, worker: worker)
        interactor.handle(action: .openDetails)
        
        wait(for: [routerCalledExpectation, routerCompletedExpectation], timeout: 0.1, enforceOrder: true)
    }
}
