//
//  ObjectListViewPresenter.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 26/05/2023.
//

import Foundation

enum ObjectListViewPresenterEvent {
    case loading
    case partiallyLoaded([ArtObjectSummary])
    case loaded([ArtObjectSummary])
    case error(APIError)
}

protocol ObjectListViewPresenter: Presenter<ObjectListViewPresenterEvent> where ViewUpdaterType: ObjectListViewUpdater {}
