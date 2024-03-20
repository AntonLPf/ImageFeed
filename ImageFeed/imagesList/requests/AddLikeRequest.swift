//
//  SetLikeRequest.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 10.03.24.
//

import Foundation

enum AddLikeRequest: RequestProtocol {
    case setLike(imageId: String)
    
    var path: String {
        switch self {
        case .setLike(let imageId):
            return "/photos/\(imageId)/like"
        }
    }
    
    var host: String {
        Constants.UnsplashApi.apiHost
    }
    
    var requestType: RequestType {
        .POST
    }
}
