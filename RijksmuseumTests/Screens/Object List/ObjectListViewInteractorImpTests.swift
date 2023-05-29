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
    
    func test_onRequestObjects_executesWorkerAndUpdatesPresenter() async throws {
        
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
        worker.onLoadListItems = { _, _ in
            workerCalledExpectation.fulfill()
        }
        
        let interactor = ObjectListViewInteractorImp(router: router, presenter: presenter, worker: worker)
        await MainActor.run {
            interactor.handle(action: .requestObjects)
        }
        
        await fulfillment(of: [startLoadingExpectation,
                               workerCalledExpectation,
                               loadedExpectation,
                               presenterCompletedExpectation], timeout: 0.1, enforceOrder: true)
    }
    
    func test_onRequestObjectsWithError_executesWorkerAndUpdatesPresenter() throws {
        let expectedError = APIError.network
        
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
                    
                    XCTAssertEqual(expectedError, error)
                    errorExpectation.fulfill()
                }], presenterCompletedExpectation))
        
        let worker = MockObjectListViewWorker()
        worker.loadListItemsResult = .failure(expectedError)
        worker.onLoadListItems = { _, _ in
            workerCalledExpectation.fulfill()
        }
        
        let interactor = ObjectListViewInteractorImp(router: router, presenter: presenter, worker: worker)
        interactor.handle(action: .requestObjects)
        
        wait(for: [startLoadingExpectation,
                   workerCalledExpectation,
                   errorExpectation,
                   presenterCompletedExpectation], timeout: 0.1, enforceOrder: true)
    }
    
    func test_onRequestObjectsWithItemCountEqualToPageSize_updatesPresenterWithPartiallyLoaded() async throws {
        
        let startLoadingExpectation = expectation(description: "Loading event sent.")
        let partiallyLoadedExpectation = expectation(description: "Partially loaded event sent.")
        let presenterCompletedExpectation = expectation(description: "Presented completed.")
        
        let workerResponse: [ArtObjectSummary] = Array(repeating: .init(id: "", title: "", imageURL: .test), count: 20)
        let router = MockViewRouter<ObjectListViewRouterAction>(eventProcessor: .none)
        let presenter = MockViewPresenter<ObjectListViewPresenterEvent, PaginatedViewState<[ObjectSummaryCellViewModel]>>(eventProcessor:
                .events([{ event in
                    guard case .loading = event else {
                        XCTFail("Expected loading event but got \(event).")
                        return
                    }
                    
                    startLoadingExpectation.fulfill()
                }, { event in
                    guard case .partiallyLoaded(let items) = event else {
                        XCTFail("Expected partially loaded event but got \(event).")
                        return
                    }
                    
                    XCTAssertEqual(items, workerResponse)
                    partiallyLoadedExpectation.fulfill()
                }], presenterCompletedExpectation))
        
        let worker = MockObjectListViewWorker()
        worker.loadListItemsResult = .success(workerResponse)
        
        let interactor = ObjectListViewInteractorImp(router: router, presenter: presenter, worker: worker)
        await MainActor.run {
            interactor.handle(action: .requestObjects)
        }
        
        await fulfillment(of: [startLoadingExpectation,
                               partiallyLoadedExpectation,
                               presenterCompletedExpectation], timeout: 0.1, enforceOrder: true)
    }
    
    func test_onRequestObjectsWithItemCountSmallerThanPageSize_updatesPresenterWithLoaded() async throws {
        
        let startLoadingExpectation = expectation(description: "Loading event sent.")
        let loadedExpectation = expectation(description: "Loaded event sent.")
        let presenterCompletedExpectation = expectation(description: "Presented completed.")
        
        let workerResponse: [ArtObjectSummary] = [.init(id: "", title: "", imageURL: .test)]
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
        
        let interactor = ObjectListViewInteractorImp(router: router, presenter: presenter, worker: worker)
        await MainActor.run {
            interactor.handle(action: .requestObjects)
        }
        
        await fulfillment(of: [startLoadingExpectation,
                               loadedExpectation,
                               presenterCompletedExpectation], timeout: 0.1, enforceOrder: true)
    }
    
    func test_onRequestObjectsWithEmptyResponseAfterFullResponse_updatesPresenterWithLoaded() async throws {
        
        let firstLoadingExpectation = expectation(description: "First loading event sent.")
        let partiallyLoadedExpectation = expectation(description: "Partially loaded event sent.")
        let loadedExpectation = expectation(description: "Loaded event sent.")
        let presenterCompletedExpectation = expectation(description: "Presented completed.")
        
        let firstResponse: [ArtObjectSummary] = Array(repeating: .init(id: "", title: "", imageURL: .test), count: 20)
        
        let router = MockViewRouter<ObjectListViewRouterAction>(eventProcessor: .none)
        let presenter = MockViewPresenter<ObjectListViewPresenterEvent, PaginatedViewState<[ObjectSummaryCellViewModel]>>(eventProcessor:
                .events([{ event in
                    guard case .loading = event else {
                        XCTFail("Expected loading event but got \(event).")
                        return
                    }
                    
                    firstLoadingExpectation.fulfill()
                }, { event in
                    guard case .partiallyLoaded(let items) = event else {
                        XCTFail("Expected partially loaded event but got \(event).")
                        return
                    }
                    
                    XCTAssertEqual(items, firstResponse)
                    partiallyLoadedExpectation.fulfill()
                }, { event in
                    guard case .loaded(let items) = event else {
                        XCTFail("Expected loaded event but got \(event).")
                        return
                    }
                    
                    XCTAssertEqual(items, firstResponse)
                    loadedExpectation.fulfill()
                }], presenterCompletedExpectation))
        
        let worker = MockObjectListViewWorker()
        worker.loadListItemsResult = .success(firstResponse)
        
        let interactor = ObjectListViewInteractorImp(router: router, presenter: presenter, worker: worker)
        await MainActor.run {
            interactor.handle(action: .requestObjects)
        }
        
        await fulfillment(of: [firstLoadingExpectation,
                               partiallyLoadedExpectation], timeout: 0.1, enforceOrder: true)
        
        worker.loadListItemsResult = .success([])
        
        await MainActor.run {
            interactor.handle(action: .requestObjects)
        }
        
        await fulfillment(of: [loadedExpectation,
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
        interactor.handle(action: .openDetails(id: ""))
        
        wait(for: [routerCalledExpectation, routerCompletedExpectation], timeout: 0.1, enforceOrder: true)
    }
}
