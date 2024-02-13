//
//  ApiManager.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 12.02.24.
//

import Foundation

protocol APIManagerProtocol {
    func perform(_ request: RequestProtocol) async throws -> Data
}

class APIManager: APIManagerProtocol {
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func perform(_ request: RequestProtocol) async throws -> Data {
        do {
            let (data, response) = try await urlSession.data(for: request.createURLRequest())
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Response status code: \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                print((response as? HTTPURLResponse)?.description ?? "Error to get description")
                
                if let responseDataString = String(data: data, encoding: .utf8) {
                    print("Response Body: \(responseDataString)")
                }
                
                throw NetworkError.invalidServerResponse
                
            }
            
            return data
        } catch {
            print("Error performing request: \(error)")
            throw error
        }
    }
}
