//
//  APIClient.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import Foundation

protocol APIClient {
    
    func getObjectSummaries(for page: Int, with size: Int) async throws -> [ArtObjectSummary]
    func getObjectDetails(with id: String) async throws -> ArtObject
}
