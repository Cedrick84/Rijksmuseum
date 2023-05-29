//
//  ObjectDetailsViewProtocols.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import Foundation

protocol ObjectDetailsViewActionListener {
    var actionListener: (any ActionListener<ObjectDetailsViewAction>)? { get set }
}

protocol ObjectDetailsViewUpdater: ViewUpdater<ViewState<ObjectDetailViewModel>> {}
