//
//  APIToken.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 12.02.24.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let refreshToken: String
    let scope: String
    let createdAt: Int
    let userId: Int
    let username: String
}

// MARK: - Helper properties
extension OAuthTokenResponseBody {
    
    var bearerAccessToken: String {
        "\(tokenType) \(accessToken)"
    }
}
