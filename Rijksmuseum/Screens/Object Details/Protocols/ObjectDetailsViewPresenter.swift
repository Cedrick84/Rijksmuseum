//
//  ObjectDetailsViewPresenter.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import Foundation

enum ObjectDetailsViewPresenterEvent {
    case loading
    case loaded(ArtObject)
    case error(APIError)
}

protocol ObjectDetailsViewPresenter: Presenter<ObjectDetailsViewPresenterEvent> where ViewUpdaterType: ObjectDetailsViewUpdater {}
