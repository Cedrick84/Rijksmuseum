//
//  ImageDownloaderImp.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import UIKit

actor ImageDownloaderImp: ImageDownloader {
    
    private enum LoadState {
        case loading(Task<UIImage, Error>)
        case loaded(UIImage)
    }
    
    private var cache: [URL: LoadState] = [:]
    private let networkContentRetriever: NetworkContentRetriever
    private let imageMapper: ((UIImage) -> UIImage)?
    
    init(networkContentRetriever: NetworkContentRetriever = URLSession.shared,
         imageMapper: ((UIImage) -> UIImage)? = nil) {
        
        self.networkContentRetriever = networkContentRetriever
        self.imageMapper = imageMapper
    }
    
    func image(for url: URL) async throws -> UIImage {
        if let state = cache[url] {
            switch state {
            case .loading(let task):
                return try await task.value
            case .loaded(let image):
                return image
            }
        }
        
        let request = URLRequest(url: url)
        
        let task: Task<UIImage, Error> = Task {
            let (data, _) = try await networkContentRetriever.data(for: request)
            guard let image = UIImage(data: data) else {
                cache[url] = nil
                return UIImage()
            }
            
            if let imageMapper {
                return imageMapper(image)
            }
            
            return image
        }
        
        cache[url] = .loading(task)
        let image = try await task.value
        cache[url] = .loaded(image)
        
        return image
    }
}
