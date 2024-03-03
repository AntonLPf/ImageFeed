//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 03.03.24.
//

import Foundation

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let description: String?
    let urls: UrlsResult
    let likedByUser: Bool
    
    struct UrlsResult: Decodable {
        let thumb: String
        let full: String
    }
}
