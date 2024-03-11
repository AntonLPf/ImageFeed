//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 11.03.24.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private let oauthService = OAuth2Service.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared
    
    private init() { }
    
    func logout() {
        oauthService.removeTokenAndReset()
        profileService.reset()
        profileImageService.reset()
        imagesListService.reset()
        cleanCookies()
    }
        
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
    
