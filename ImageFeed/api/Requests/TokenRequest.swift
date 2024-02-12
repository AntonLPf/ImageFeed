//
//  TokenRequest.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 12.02.24.
//

import Foundation

enum TokenRequest: RequestProtocol {
    case getToken(code: String)
    
    var host: String { ProjectConstants.SplashApi.host }
    
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
                "client_id": ProjectConstants.SplashApi.accesKey,
                "client_secret": ProjectConstants.SplashApi.secretKey,
                "redirect_uri": ProjectConstants.SplashApi.redirectUri,
                "code": code,
                "grant_type": "authorization_code"
            ]
        }
    }
}
