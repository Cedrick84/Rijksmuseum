//
//  ObjectListViewPresenterImp.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 26/05/2023.
//

import Foundation

// Strings should be localized and not hard coded here
extension APIError {
    var message: String {
        switch self {
        case .network:
            return "Something went wrong reaching our server, please make sure you're online and try again."
        case .decoding:
            return "Something went really wrong here, please contact customer support and give them the code: DECODING_ERROR."
        case .unknown:
            return "Something went really wrong here, please contact customer support."
        }
    }
}

final class ObjectListViewPresenterImp<ViewUpdater: ObjectListViewUpdater>: ObjectListViewPresenter {
    
    init(viewUpdater: ViewUpdater) {
        self.viewUpdater = viewUpdater
    }

    weak var viewUpdater: ViewUpdater?

    func process(event: ObjectListViewPresenterEvent) {
        switch event {
        case .loading:
            viewUpdater?.update(state: .loading)
        case .partiallyLoaded(let items):
            viewUpdater?.update(state: .partiallyLoaded(items.map({ ObjectSummaryCellViewModel($0) })))
        case .loaded(let items):
            if items.isEmpty {
                viewUpdater?.update(state: .empty)
            } else {
                viewUpdater?.update(state: .loaded(items.map({ ObjectSummaryCellViewModel($0) })))
            }
        case .error(let error):
            viewUpdater?.update(state: .error(error.message))
        }
    }
}
