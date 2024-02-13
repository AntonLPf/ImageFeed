//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 12.02.24.
//

import Foundation

protocol OAuth2ServiceProtocol {
    var token: OAuthTokenResponseBody? { get }
    func fetchAuthToken(code: String) async throws
}

final class OAuth2Service: OAuth2ServiceProtocol {
    private let requestManager: RequestManagerProtocol
    private let storage: KeyValueStorageProtocol
    private let tokenStorageKey: String
    
    var token: OAuthTokenResponseBody?
    
    init(requestManager: RequestManagerProtocol = RequestManager(), 
         storage: KeyValueStorageProtocol = UserDefaultsManager()) {
        self.requestManager = requestManager
        self.storage = storage
        self.tokenStorageKey = Constants.UserDefaultsKey.token.rawValue
        
        do {
            let storedToken = try storage.load(key: tokenStorageKey, OAuthTokenResponseBody.self)
            if let oauthToken = storedToken as? OAuthTokenResponseBody {
                self.token = oauthToken
            } else {
                fatalError("Unable to cast Stored Token to OAuthTokenResponseBody") // TODO: убрать. Сделано на время дебага
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func fetchAuthToken(code: String) async throws {
        let request = TokenRequest.getToken(code: code)
        let token: OAuthTokenResponseBody = try await requestManager.perform(request)
        debugPrint(">>> OauthToken Recieved")
        self.token = token
        saveToStorage(token: token)
    }
    
    private func saveToStorage(token: OAuthTokenResponseBody) {
        do {
            try storage.save(codable: token, key: tokenStorageKey)
            debugPrint(">>> OauthToken saved to storage")
        } catch {
            fatalError("Unable to save Token to Storage") // TODO: убрать. Сделано на время дебага
        }
    }
}
