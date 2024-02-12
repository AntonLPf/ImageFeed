//
//  RequestManager.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 12.02.24.
//

import Foundation

protocol RequestManagerProtocol {
    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
}

class RequestManager: RequestManagerProtocol {
    let apiManager: APIManagerProtocol
    let parser: DataParserProtocol
    
    init(apiManager: APIManagerProtocol = APIManager(),
         parser: DataParserProtocol = DataParser()) {
        self.apiManager = apiManager
        self.parser = parser
    }
    
    func perform<T>(_ request: RequestProtocol) async throws -> T where T : Decodable {
        
        let authToken = APIToken(
            accessToken: "", 
            tokenType: "Bearer",
            refreshToken: "",
            scope: "",
            createdAt: 0,
            userId: 0,
            username: "")
            .bearerAccessToken
                
        let data = try await apiManager.perform(request, authToken: authToken)

        let decoded: T = try parser.parse(data: data)
                
        return decoded
    }
}
