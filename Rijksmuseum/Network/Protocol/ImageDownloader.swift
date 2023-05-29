//
//  ImageDownloader.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import UIKit

protocol ImageDownloader {
    
    func image(for url: URL) async throws -> UIImage?
}
