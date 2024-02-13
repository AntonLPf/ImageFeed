//
//  KeyValueStorageProtocol.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 13.02.24.
//

import Foundation

protocol KeyValueStorageProtocol {
    func save(codable: Codable, key: String) throws
    func load<T: Codable>(key: String,_ type: T.Type) throws -> Codable
}
