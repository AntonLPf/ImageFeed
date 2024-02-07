//
//  ApiConstants.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 05.02.24.
//

import Foundation

struct Constants {
    
    struct SegueId {
        static let showWebViewSegue = "ShowWebView"
    }
    
    struct Api {
        static let accesKey = "gOcCwhsMrjRXy83ALiImrfQhnm2-NoA5TL3-MeHbRMA"
        static let secretKey = "EI7spYRB6F_WOjKYB2r2uB3Npg9ctzv17v7AV_IgD9Y"
        static let redirectUri = "urn:ietf:wg:oauth:2.0:oob"
        static let accessScope = "public+read_user+write_likes"
        static let defaultBaseUrl = URL(string: "https://api.unsplash.com")
        static let authorizingUrlString = "https://unsplash.com/oauth/authorize"
    }
}
