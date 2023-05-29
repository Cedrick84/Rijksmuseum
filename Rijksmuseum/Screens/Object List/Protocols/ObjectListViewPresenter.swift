//
//  ObjectListViewPresenter.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 26/05/2023.
//

import Foundation

enum ObjectListViewPresenterEvent {
    case loading
    case loaded([ArtObjectSummary])
    case error(Error)
}

protocol ObjectListViewPresenter: Presenter<ObjectListViewPresenterEvent> where ViewUpdaterType: ObjectListViewUpdater {}
