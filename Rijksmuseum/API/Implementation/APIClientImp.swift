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

protocol URLContentRetriever {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLContentRetriever {}

protocol JSONDecoderProtocol {
    func decode<T>(_ type: T.Type, from data: Data, keyPath: String, keyPathSeparator separator: String) throws -> T where T: Decodable
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

extension JSONDecoder: JSONDecoderProtocol {}

struct APIClientImp: APIClient {
    
    private let urlContentRetriever: URLContentRetriever
    private let jsonDecoder: JSONDecoderProtocol
    
    init(urlContentRetriever: URLContentRetriever = URLSession.shared,
         jsonDecoder: JSONDecoderProtocol = JSONDecoder()) {
        self.urlContentRetriever = urlContentRetriever
        self.jsonDecoder = jsonDecoder
    }
    
    enum Endpoint {
        case list(page: Int, size: Int)
        case details(id: String)
        
        private var baseURL: String { "https://www.rijksmuseum.nl/api/nl/" }
        private var apiKey: String { "0fiuZFh4" }
        
        var url: URL {
            switch self {
            case let .list(page, size):
                return URL(string: "\(baseURL)collection?key=\(apiKey)&involvedMaker=Rembrandt+van+Rijn&imgonly=True&p=\(String(page))&ps=\(String(size))")!
            case let .details(id):
                return URL(string: "\(baseURL)collection/\(id)?key=\(apiKey)")!
            }
        }
        
        var decodingKeyPath: String {
            switch self {
            case .list: return "artObjects"
            case .details: return "artObject"
            }
        }
    }
    
    func getObjectSummaries(for page: Int, with size: Int) async throws -> [ArtObjectSummary] {
        let endpoint = Endpoint.list(page: page, size: size)
        let objects = try await map(object: [ArtObjectSummary].self,
                                    from: endpoint.url,
                                    at: endpoint.decodingKeyPath)
        return objects
    }
    
    func getObjectDetails(with id: String) async throws -> ArtObject {
        let endpoint = Endpoint.details(id: id)
        return try await map(object: ArtObject.self, from: endpoint.url, at: endpoint.decodingKeyPath)
    }
    
    private func map<T: Decodable>(object: T.Type, from url: URL, at keyPath: String) async throws -> T {
        guard let (data, _) = try? await urlContentRetriever.data(from: url) else {
            throw APIError.network
        }
        
        guard let result = try? jsonDecoder.decode(T.self, from: data, keyPath: keyPath, keyPathSeparator: ".") else {
            throw APIError.decoding
        }
        
        return result
    }
}
