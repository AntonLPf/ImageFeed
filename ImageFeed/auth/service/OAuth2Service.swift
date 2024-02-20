//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 12.02.24.
//

import Foundation

protocol OAuth2ServiceProtocol {
    var token: OAuthTokenResponseBody? { get }
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void)
}

final class OAuth2Service: OAuth2ServiceProtocol {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private let storage: KeyValueStorageProtocol
    private let tokenStorageKey: String
    
    var token: OAuthTokenResponseBody?
    
    private init(storage: KeyValueStorageProtocol = UserDefaultsManager()) {
        self.storage = storage
        self.tokenStorageKey = Constants.UserDefaultsKey.token.rawValue
        
        if let storedToken = try? storage.load(key: tokenStorageKey, OAuthTokenResponseBody.self) {
            debugPrint(">>> Found stored auth token. User Authorized")
            self.token = storedToken
        } else {
            debugPrint(">>> Faied to load token. Need to authorise/reauthorized")
        }
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        guard let request = try? TokenRequest.getToken(code: code).createURLRequest() else {
            preconditionFailure("Invalid token request configuration")
        }
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error {
                    self.lastCode = nil
                    completion(.failure(error))
                } else if let httpResponse = response as? HTTPURLResponse {
                    
                    let statusCode = httpResponse.statusCode
                    
                    switch statusCode {
                    case 200..<300:
                        let parser = DataParser()
                        if
                            let data,
                            let token: OAuthTokenResponseBody = try? parser.parse(data: data) {
                            self.token = token
                            self.saveToStorage(token: token)
                            completion(.success(""))
                        } else {
                            let error = NetworkError.parsingError
                            completion(.failure(error))
                            assertionFailure(error.errorDescription)
                        }
                    default:
                        self.lastCode = nil
                        completion(.failure(NetworkError.httpStatusCode(statusCode)))
                    }
                }
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    private func saveToStorage(token: OAuthTokenResponseBody) {
        do {
            try storage.save(codable: token, key: tokenStorageKey)
            debugPrint(">>> OauthToken Saved to Storage")
        } catch {
            preconditionFailure("Unable to save Token to Storage")
        }
    }
}
