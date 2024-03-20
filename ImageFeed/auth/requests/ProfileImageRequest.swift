//
//  ProfileImageRequest.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 24.02.24.
//

import Foundation

enum ProfileImageRequest: RequestProtocol {
    case getUser(userName: String)
    
    var host: String {
        Constants.UnsplashApi.apiHost
    }
    
    var requestType: RequestType {
        .GET
    }
        
    var path: String {
        switch self {
        case .getUser(let userName):
            "/users/\(userName)"
        }
      
    }
}
