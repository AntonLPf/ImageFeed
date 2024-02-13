//
//  TokenRequest.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 12.02.24.
//

import Foundation

enum TokenRequest: RequestProtocol {
    case getToken(code: String)
    
    var host: String { Constants.SplashApi.host }
    
    var requestType: RequestType { .POST }
    
    var addAuthorizationToken: Bool {
        false
    }
    
    var path: String {
      "/oauth/token"
    }
    
    var params: [String : Any] {
        switch self {
        case .getToken(let code):
            return [
                "client_id": Constants.SplashApi.accesKey,
                "client_secret": Constants.SplashApi.secretKey,
                "redirect_uri": Constants.SplashApi.redirectUri,
                "code": code,
                "grant_type": "authorization_code"
            ]
        }
    }
}
