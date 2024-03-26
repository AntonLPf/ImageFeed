//
//  ProjectColor.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 30.01.24.
//

import Foundation

enum Constants {
    
    struct AuthConfiguration {
        let accessKey: String
        let secretKey: String
        let redirectURI: String
        let accessScope: String
        let defaultBaseURL: URL
        let authURLString: String

        init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
            self.accessKey = accessKey
            self.secretKey = secretKey
            self.redirectURI = redirectURI
            self.accessScope = accessScope
            self.defaultBaseURL = defaultBaseURL
            self.authURLString = authURLString
        }
        
        static var standard: AuthConfiguration {
                return AuthConfiguration(accessKey: UnsplashApi.accessKey,
                                         secretKey: UnsplashApi.secretKey,
                                         redirectURI: UnsplashApi.redirectUri,
                                         accessScope: UnsplashApi.accessScope,
                                         authURLString: UnsplashApi.authorizingUrlString,
                                         defaultBaseURL: UnsplashApi.defaultBaseUrl)
            }
    }
    
    struct Color {
        static let ypBlack = "YPBlack"
        static let ypWhite = "YPWhite"
        static let ypGray = "YPGray"
    }
    
    struct Font {
        static let ysDisplayBold = "YSDisplay-Bold"
        static let ysDisplayMedium = "YSDisplay-Medium"
    }
    
    struct Picture {
        static let exitButton = "ExitButton"
        static let shareButton = "ShareButton"
        static let backward = "Backward"
        static let profilePicture = "ProfilePicture"
        static let profilePicturePlaceHolder = "ProfilePicturePlaceholder"
        static let practicumLogo = "PracticumLogo"
        static let navBackButton = "nav_back_button"
        static let authScreenLogo = "auth_screen_logo"
        static let imagePlaceHolder = "ImagePlaceHolder"
    }
    
    struct SegueId {
        static let showWebViewSegue = "ShowWebView"
    }
    
    struct StoryBoardViewId {
        static let tabBarViewController = "TabBarViewController"
    }
    
    struct UnsplashApi {
        static let host = "unsplash.com"
        static let apiHost = "api.unsplash.com"
        static let accessKey = "gOcCwhsMrjRXy83ALiImrfQhnm2-NoA5TL3-MeHbRMA"
        static let secretKey = "EI7spYRB6F_WOjKYB2r2uB3Npg9ctzv17v7AV_IgD9Y"
        static let redirectUri = "urn:ietf:wg:oauth:2.0:oob"
        static let accessScope = "public+read_user+write_likes"
        static let defaultBaseUrl = URL(string: "https://api.unsplash.com")!
        static let authorizingUrlString = "https://unsplash.com/oauth/authorize"
        
        static let numberOfImagesPerPage = 10
    }
    
    enum UserDefaultsKey: String {
        case token
    }
    
    struct NCNotification {
        static let profileImageProviderDidChange = "ProfileImageProviderDidChange"
        static let imagesListServiceDidChange = "ImagesListServiceDidChange"
    }
}
