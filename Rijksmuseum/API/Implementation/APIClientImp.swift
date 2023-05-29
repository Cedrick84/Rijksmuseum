//
//  APIClientImp.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import Foundation

enum APIError: Error {
    case network
    case decoding
    case unknown
}

struct APIClientImp: APIClient {
    
    private enum Endpoint {
        case list(page: Int, size: Int)
        case details(id: String)
        
        private var baseURL: String { "https://www.rijksmuseum.nl/api/nl/" }
        private var apiKey: String { "0fiuZFh4" } // TODO: Document
        
        var url: URL {
            switch self {
            case let .list(page, size):
                return URL(string: "\(baseURL)collection?key=\(apiKey)&involvedMaker=Rembrandt+van+Rijn&imgonly=True&p=\(String(page))&ps=\(String(size))")!
            case let .details(id):
                return URL(string: "\(baseURL)collection/\(id)?key=\(apiKey)")!
            }
        }
    }
    
    func getObjectSummaries(for page: Int, with size: Int) async throws -> [ArtObjectSummary] {
        let response = try await map(object: CollectionListResponse.self, from: Endpoint.list(page: page, size: size).url)
        return response.objectSummaries
    }
    
    func getObjectDetails(with id: String) async throws -> ArtObject {
        return try await map(object: ArtObject.self, from: Endpoint.details(id: id).url)
    }
    
    private func map<T: Decodable>(object: T.Type, from url: URL) async throws -> T {
        guard let (data, _) = try? await URLSession.shared.data(from: url) else {
            throw APIError.network
        }
        
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            throw APIError.decoding
        }
        
        return result
    }
}
