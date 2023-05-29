//
//  MockProtocols.swift
//  RijksmuseumTests
//
//  Created by Cedrick Gout on 26/05/2023.
//

import Foundation
@testable import Rijksmuseum

extension MockViewUpdater<PaginatedViewState<[ObjectSummaryCellViewModel]>>: ObjectListViewUpdater {}
extension MockViewPresenter<ObjectListViewPresenterEvent, PaginatedViewState<[ObjectSummaryCellViewModel]>>: ObjectListViewPresenter {}
extension MockViewRouter<ObjectListViewRouterAction>: ObjectListViewRouter {}
