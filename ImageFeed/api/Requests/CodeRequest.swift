//
//  CodeRequest.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 12.02.24.
//

import Foundation

enum CodeRequest: RequestProtocol {
    case getCode
    
    var host: String { ProjectConstants.SplashApi.host }
    
    var requestType: RequestType { .GET }
    
    var addAuthorizationToken: Bool {
        false
    }
    
    var path: String {
      "/oauth/authorize"
    }
    
    var urlParams: [String : String?] {
        [
            "client_id": ProjectConstants.SplashApi.accesKey,
            "redirect_uri": ProjectConstants.SplashApi.redirectUri,
            "response_type": "code",
            "scope": ProjectConstants.SplashApi.accessScope
        ]
    }
}
