//
//  RequestProtocol.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 12.02.24.
//

import Foundation

protocol RequestProtocol {
    var host: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var params: [String: Any] { get }
    var urlParams: [String: String?] { get }
    var isAuthorizationNeeded: Bool { get }
    var requestType: RequestType { get }
}

extension RequestProtocol {
    
    var host: String {
        Constants.SplashApi.host
    }
        
    var params: [String: Any] {
        [:]
    }
    
    var urlParams: [String: String?] {
        [:]
    }
    
    var headers: [String: String] {
        [:]
    }
    
    var isAuthorizationNeeded: Bool {
        true
    }
    
    func createURLRequest(token: String?) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
                
        if !urlParams.isEmpty {
            components.queryItems = urlParams.map {
                URLQueryItem(name: $0, value: $1)
            }
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        
        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        if isAuthorizationNeeded {
            guard let token else {
                assertionFailure("Token required")
                throw NetworkError.noToken
            }
            urlRequest.setValue("\(token)", forHTTPHeaderField: "Authorization")
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }
                
        return urlRequest
    }
}
