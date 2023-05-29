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

    init(router: Router,
         presenter: Presenter,
         worker: ObjectListViewWorker = ObjectListViewWorkerImp()) {

        self.router = router
        self.presenter = presenter
        self.worker = worker
    }

    func handle(action: ObjectListViewAction) {
        switch action {
        case .requestList:
            requestList()
        case .openDetails:
            router?.handle(action: .openDetails)
        }
    }

    @MainActor
    private func requestList() {
        presenter.process(event: .loading)
        
        Task {
            do {
                let items = try await worker.loadListItems()
                presenter.process(event: .loaded(items))
            } catch {
                presenter.process(event: .error(error))
            }
        }
    }
}
