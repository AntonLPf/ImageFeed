//
//  TokenRequest.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 12.02.24.
//

import Foundation

enum TokenRequest: RequestProtocol {
    case getToken(code: String)
        
    var requestType: RequestType {
        .POST
    }
    
    var isAuthorizationNeeded: Bool {
        false
    }
        
    var path: String {
      "/oauth/token"
    }
    
    var params: [String : Any] {
        switch self {
        case .getToken(let code):
            return [
                "client_id": Constants.UnsplashApi.accessKey,
                "client_secret": Constants.UnsplashApi.secretKey,
                "redirect_uri": Constants.UnsplashApi.redirectUri,
                "code": code,
                "grant_type": "authorization_code"
            ]
        }
    }
}
