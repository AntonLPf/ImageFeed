//
//  ProjectColor.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 30.01.24.
//

import Foundation

struct ProjectConstants {
    
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
        static let profilePicture = "ProfilePicture"
    }
    
    struct SegueId {
        static let showWebViewSegue = "ShowWebView"
    }
    
    struct SplashApi {
        static let host = "unsplash.com"
        
        static let accesKey = "TTxNmP3O3DhG3TyWrnQs_Ry_fXjSSExAI6WIe8WmENw"
        static let secretKey = "PU9_PPg5qpOgAVsMog9TqURjhiobKqjCdvozO5vUxvM"
//        static let accesKey = "gOcCwhsMrjRXy83ALiImrfQhnm2-NoA5TL3-MeHbRMA"
//        static let secretKey = "EI7spYRB6F_WOjKYB2r2uB3Npg9ctzv17v7AV_IgD9Y"
        static let redirectUri = "urn:ietf:wg:oauth:2.0:oob"
        static let accessScope = "public+read_user+write_likes"
        static let defaultBaseUrl = URL(string: "https://api.unsplash.com")
        static let authorizingUrlString = "https://unsplash.com/oauth/authorize"
    }
    
    enum UserDefaultsKey: String {
        case token
    }
}
