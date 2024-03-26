//
//  CodeRequest.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 12.02.24.
//

import Foundation

enum CodeRequest: RequestProtocol {
    case getCode
        
    var requestType: RequestType {
        .GET
    }
        
    var path: String {
      "/oauth/authorize"
    }
    
    var isAuthorizationNeeded: Bool {
        false
    }
    
    var urlParams: [String : String?] {
        [
            "client_id": Constants.UnsplashApi.accessKey,
            "redirect_uri": Constants.UnsplashApi.redirectUri,
            "response_type": "code",
            "scope": Constants.UnsplashApi.accessScope
        ]
    }
}
