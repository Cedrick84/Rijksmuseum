//
//  JSONDecoder+KeyPath.swift
//  Rijksmuseum
//
//  Created by Cedrick Gout on 29/05/2023.
//

import Foundation

// Stolen from: https://github.com/0111b/JSONDecoder-Keypath
extension JSONDecoder {
    
    func decode<T>(_ type: T.Type,
                   from data: Data,
                   keyPath: String,
                   keyPathSeparator separator: String = ".") throws -> T where T: Decodable {
        userInfo[keyPathUserInfoKey] = keyPath.components(separatedBy: separator)
        return try decode(KeyPathWrapper<T>.self, from: data).object
    }
}

private let keyPathUserInfoKey = CodingUserInfoKey(rawValue: "keyPathUserInfoKey")!
private final class KeyPathWrapper<T: Decodable>: Decodable {
    
    enum KeyPathError: Error {
        case `internal`
    }
    
    struct Key: CodingKey {
        init?(intValue: Int) {
            self.intValue = intValue
            stringValue = String(intValue)
        }
        
        init?(stringValue: String) {
            self.stringValue = stringValue
            intValue = nil
        }
        
        let intValue: Int?
        let stringValue: String
    }
    
    typealias KeyedContainer = KeyedDecodingContainer<KeyPathWrapper<T>.Key>
    
    init(from decoder: Decoder) throws {
        guard let keyPath = decoder.userInfo[keyPathUserInfoKey] as? [String],
              !keyPath.isEmpty
        else { throw KeyPathError.internal }
        
        func getKey(from keyPath: [String]) throws -> Key {
            guard let first = keyPath.first,
                  let key = Key(stringValue: first)
            else { throw KeyPathError.internal }
            return key
        }
        
        func objectContainer(for keyPath: [String],
                             in currentContainer: KeyedContainer,
                             key currentKey: Key) throws -> (KeyedContainer, Key) {
            guard !keyPath.isEmpty else { return (currentContainer, currentKey) }
            let container = try currentContainer.nestedContainer(keyedBy: Key.self, forKey: currentKey)
            let key = try getKey(from: keyPath)
            return try objectContainer(for: Array(keyPath.dropFirst()), in: container, key: key)
        }
        
        let rootKey = try getKey(from: keyPath)
        let rootContainer = try decoder.container(keyedBy: Key.self)
        let (keyedContainer, key) = try objectContainer(for: Array(keyPath.dropFirst()), in: rootContainer, key: rootKey)
        object = try keyedContainer.decode(T.self, forKey: key)
    }
    
    let object: T
}
