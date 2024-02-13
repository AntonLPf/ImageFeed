//
//  KeyValueStorageProtocol.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 13.02.24.
//

import Foundation

protocol KeyValueStorageProtocol {
    func save(codable: Encodable, key: String) throws
    func load<T: Decodable>(key: String,_ type: T.Type) throws -> T
}
