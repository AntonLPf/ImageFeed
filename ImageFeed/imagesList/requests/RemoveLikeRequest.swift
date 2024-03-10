//
//  RemoveLikeRequest.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 10.03.24.
//

import Foundation

enum RemoveLikeRequest: RequestProtocol {
    case removeLike(imageId: String)
    
    var path: String {
        switch self {
        case .removeLike(let imageId):
            return "/photos/\(imageId)/like"
        }
    }
    
    var host: String {
        Constants.SplashApi.apiHost
    }
    
    var requestType: RequestType {
        .DELETE
    }
}
