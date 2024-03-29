//
//  ProjectColor.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 30.01.24.
//

import Foundation

enum Constants {
    
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
    
    struct SplashApi {
        static let host = "unsplash.com"
        static let apiHost = "api.unsplash.com"
        static let accesKey = "gOcCwhsMrjRXy83ALiImrfQhnm2-NoA5TL3-MeHbRMA"
        static let secretKey = "EI7spYRB6F_WOjKYB2r2uB3Npg9ctzv17v7AV_IgD9Y"
        static let redirectUri = "urn:ietf:wg:oauth:2.0:oob"
        static let accessScope = "public+read_user+write_likes"
        static let defaultBaseUrl = URL(string: "https://api.unsplash.com")
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
