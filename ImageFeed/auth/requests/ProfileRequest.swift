//
//  ProfileRequest.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 23.02.24.
//

import Foundation

enum ProfileRequest: RequestProtocol {
    case getProfile
    
    var host: String {
        Constants.SplashApi.apiHost
    }
    
    var requestType: RequestType {
        .GET
    }
        
    var path: String {
      "/me"
    }
}
