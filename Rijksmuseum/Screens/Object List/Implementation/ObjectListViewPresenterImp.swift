//
//  ObjectListViewPresenterImp.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 26/05/2023.
//

import Foundation

final class ObjectListViewPresenterImp<ViewUpdater: ObjectListViewUpdater>: ObjectListViewPresenter {
    
    init(viewUpdater: ViewUpdater) {
        self.viewUpdater = viewUpdater
    }

    weak var viewUpdater: ViewUpdater?

    func process(event: ObjectListViewPresenterEvent) {
        switch event {
        case .loading:
            viewUpdater?.update(state: .loading)
        case .loaded(let items):
            if items.isEmpty {
                viewUpdater?.update(state: .empty)
            } else {
                viewUpdater?.update(state: .loaded(items.map({ ObjectSummaryCellViewModel($0) })))
            }
        case .error(let error):
            viewUpdater?.update(state: .error(error.localizedDescription))
        }
    }
}
