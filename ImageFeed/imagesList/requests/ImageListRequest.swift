//
//  ImageListRequest.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 03.03.24.
//

import Foundation

enum ImageListRequest: RequestProtocol {
    case getImages(page: Int?, perPage: Int?)
    
    var path: String {
        "/photos"
    }
    
    var host: String {
        Constants.UnsplashApi.apiHost
    }
    
    var requestType: RequestType {
        .GET
    }
    
    var urlParams: [String : String?] {
        var result: [String : String?] = [:]
        
        switch self {
        case .getImages(page: let page, perPage: let perPage):
            if let page {
                result["page"] = page.description
            }
            if let perPage {
                result["per_page"] = perPage.description
            }
        }
        return result
    }
        
}
