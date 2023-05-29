//
//  ObjectDetailsViewInteractorImp.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import Foundation

final class ObjectDetailsViewInteractorImp<Presenter: ObjectDetailsViewPresenter,
                                            Router: ObjectDetailsViewRouter>: ObjectDetailsViewInteractor {

    var router: Router?
    let presenter: Presenter
    private let objectID: String
    
    private let worker: ObjectDetailsViewWorker
    private var summaries: [ArtObjectSummary] = []
    
    init(objectID: String,
         router: Router,
         presenter: Presenter,
         worker: ObjectDetailsViewWorker = ObjectDetailsViewWorkerImp()) {

        self.objectID = objectID
        self.router = router
        self.presenter = presenter
        self.worker = worker
    }

    func handle(action: ObjectDetailsViewAction) {
        switch action {
        case .requestDetails: requestDetails()
        }
    }
    
    @MainActor
    private func requestDetails() {
        presenter.process(event: .loading)
        
        Task {
            do {
                let details = try await worker.loadDetails(with: objectID)
                presenter.process(event: .loaded(details))
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
