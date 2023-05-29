//
//  APIError+Message.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import Foundation

// Strings should be localized and not hard coded here
extension APIError {
    var message: String {
        switch self {
        case .network:
            return "Something went wrong reaching our server, please make sure you're online and try again."
        case .decoding:
            return "Something went really wrong here, please contact customer support and give them the code: DECODING_ERROR."
        case .unknown:
            return "Something went really wrong here, please contact customer support."
        }
    }
}
