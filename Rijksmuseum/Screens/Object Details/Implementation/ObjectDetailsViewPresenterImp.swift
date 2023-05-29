//
//  ObjectDetailsViewPresenterImp.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import Foundation

final class ObjectDetailsViewPresenterImp<ViewUpdater: ObjectDetailsViewUpdater>: ObjectDetailsViewPresenter {
    
    init(viewUpdater: ViewUpdater) {
        self.viewUpdater = viewUpdater
    }

    weak var viewUpdater: ViewUpdater?

    func process(event: ObjectDetailsViewPresenterEvent) {
        switch event {
        case .loading:
            viewUpdater?.update(state: .loading)
        case .loaded(let item):
            viewUpdater?.update(state: .loaded(ObjectDetailViewModel(item)))
        case .error(let error):
            viewUpdater?.update(state: .error(error.message))
        }
    }
}
