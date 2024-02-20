//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 12.02.24.
//

import Foundation

enum NetworkError: LocalizedError {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidURL
    case parsingError
    
    public var errorDescription: String {
        switch self {
        case .httpStatusCode(let code):
            return "Invalid response. Code: \(code)"
        case .urlRequestError(let error):
            return "Invalid request error: \(error.localizedDescription)"
        case .urlSessionError:
            return "Url session Error"
        case .invalidURL:
            return "Invalid URL"
        case .parsingError:
            return "Parsing Error"
        }
    }
}
