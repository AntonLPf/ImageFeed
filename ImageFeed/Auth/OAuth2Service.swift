//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 12.02.24.
//

import Foundation

protocol OAuth2ServiceProtocol {
    func fetchAuthToken(code: String) async throws -> APIToken
}

struct OAuth2Service: OAuth2ServiceProtocol {
    private let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol = RequestManager()) {
        self.requestManager = requestManager
    }
    
    @MainActor
    func fetchAuthToken(code: String) async throws -> APIToken {
        let request = TokenRequest.getToken(code: code)
        let token: APIToken = try await requestManager.perform(request)
        return token
    }
}
