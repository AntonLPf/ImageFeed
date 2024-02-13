//
//  UserDefaultsManager.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 13.02.24.
//

import Foundation

class UserDefaultsManager: KeyValueStorageProtocol {
    
    enum UserDefaultsManagerError: Error, LocalizedError {
        case encodingError
        case failedLoadingData
        
        var errorDescription: String {
            switch self {
            case .encodingError:
                return "Ошибка кодирования"
            case .failedLoadingData:
                return "Ошибка загрузки данных"
            }
        }
    }
    
    private let userDefaults = UserDefaults.standard
    
    func save(codable: Encodable, key: String) throws {
        guard
            let data = try? JSONEncoder().encode(codable)
        else {
            throw UserDefaultsManagerError.encodingError
        }
        userDefaults.set(data, forKey: key)
    }
    
    func load<T: Decodable>(key: String,_ type: T.Type) throws -> T {
        guard
            let data = userDefaults.data(forKey: key),
            let loadedResult = try? JSONDecoder().decode(type, from: data)
        else {
            throw UserDefaultsManagerError.failedLoadingData
        }
        return loadedResult
    }
}
