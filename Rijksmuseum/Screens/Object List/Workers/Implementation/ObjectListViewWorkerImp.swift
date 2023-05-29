//
//  ObjectListViewWorkerImp.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 26/05/2023.
//

import Foundation

struct ObjectListViewWorkerImp: ObjectListViewWorker {
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient = APIClientImp()) {
        self.apiClient = apiClient
    }
    
    func loadListItems(for page: Int, with size: Int) async throws -> [ArtObjectSummary] {
        return try await apiClient.getObjectSummaries(for: page, with: size)
    }
}
