//
//  ObjectListViewActionListener.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 26/05/2023.
//

import Foundation

protocol ObjectListViewActionListener {
    var actionListener: (any ActionListener<ObjectListViewAction>)? { get set }
}

protocol ObjectListViewUpdater: ViewUpdater<ViewState<[ObjectSummaryCellViewModel]>> {}
