//
//  ObjectDetailsViewWorkerImp.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import Foundation

struct ObjectDetailsViewWorkerImp: ObjectDetailsViewWorker {
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient = APIClientImp()) {
        self.apiClient = apiClient
    }
    
    func loadDetails(with id: String) async throws -> ArtObject {
        return try await apiClient.getObjectDetails(with: id)
    }
}
