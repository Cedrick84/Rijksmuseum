//
//  ObjectListViewInteractorImp.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 26/05/2023.
//

import Foundation

final class ObjectListViewInteractorImp<Presenter: ObjectListViewPresenter, Router: ObjectListViewRouter>: ObjectListViewInteractor {

    var router: Router?
    let presenter: Presenter
    
    private let worker: ObjectListViewWorker
    private var summaries: [ArtObjectSummary] = []
    
    init(router: Router,
         presenter: Presenter,
         worker: ObjectListViewWorker = ObjectListViewWorkerImp()) {

        self.router = router
        self.presenter = presenter
        self.worker = worker
    }

    func handle(action: ObjectListViewAction) {
        switch action {
        case .requestObjects: requestObjects()
        case .openDetails(let id): router?.handle(action: .openDetails(id: id))
        }
    }

    @MainActor
    private func requestObjects() {
        if summaries.isEmpty {
            presenter.process(event: .loading)
        }
        
        Task {
            do {
                let pageSize = 20
                let page = summaries.count / pageSize
                
                let items = try await worker.loadListItems(for: page, with: pageSize)
                if items.isEmpty && summaries.isEmpty {
                    presenter.process(event: .loaded([]))
                } else {
                    if items.isEmpty {
                        presenter.process(event: .loaded(summaries))
                    } else {
                        summaries += items
                        
                        if items.count == pageSize {
                            presenter.process(event: .partiallyLoaded(summaries))
                        } else {
                            presenter.process(event: .loaded(summaries))
                        }
                    }
                }
            } catch {
                guard let apiError = error as? APIError else {
                    assertionFailure("Expected an APIError but got \(error).")
                    presenter.process(event: .error(.unknown))
                    return
                }
                
                presenter.process(event: .error(apiError))
            } 
        }
    }
}
