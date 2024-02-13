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
        
        if let storedToken = try? storage.load(key: tokenStorageKey, OAuthTokenResponseBody.self) as? OAuthTokenResponseBody {
            self.token = storedToken
            debugPrint(">>> OauthToken Loaded from the storage")
        } else {
            debugPrint(">>> Stored OauthToken not found")
        }
    }
    
    func fetchAuthToken(code: String) async throws {
        let request = TokenRequest.getToken(code: code)
        let token: OAuthTokenResponseBody = try await requestManager.perform(request)
        debugPrint(">>> OauthToken Fetched")
        self.token = token
        try? storage.save(codable: token, key: tokenStorageKey) //TODO: обработать ошибки
        debugPrint(">>> OauthToken saved to storage")
    }
}
