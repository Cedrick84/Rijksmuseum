//
//  Data+JSONFile.swift
//  RijksmuseumTests
//
//  Created by Cedrick Gout on 29/05/2023.
//

import Foundation

extension Data {
    
    static func from(jsonFile: String) -> Self {
        let bundle = Bundle(for: APIClientImpTests.self)
        
        guard let file = bundle.url(forResource: jsonFile, withExtension: "json"),
              let text = try? String(contentsOf: file),
              let data = text.data(using: .utf8) else {
            assertionFailure("Couldn't decode file \(jsonFile).")
            return Data()
        }

        return data
    }
}
