//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 12.02.24.
//

import Foundation

protocol OAuth2ServiceProtocol {
    var token: String? { get }
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void)
}

final class OAuth2Service: OAuth2ServiceProtocol {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private let storage: KeyValueStorageProtocol
    private let tokenStorageKey: String
    
    var token: String?
    
    private init(storage: KeyValueStorageProtocol = UserDefaultsManager()) {
        self.storage = storage
        self.tokenStorageKey = Constants.UserDefaultsKey.token.rawValue
        
        if let storedToken = try? storage.load(key: tokenStorageKey, String.self) {
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
        
        guard let request = try? TokenRequest.getToken(code: code).createURLRequest(token: nil) else {
            preconditionFailure("Invalid token request configuration")
        }
        
        let task = urlSession.objectTask(for: request) { (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let token):
                let bearerAccessToken = token.bearerAccessToken
                self.token = bearerAccessToken
                completion(.success(bearerAccessToken))
                self.saveToStorage(token: bearerAccessToken)
            case .failure(let error):
                ErrorPrinterService.shared.printToConsole(error)
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func saveToStorage(token: String) {
        do {
            try storage.save(codable: token, key: tokenStorageKey)
            debugPrint(">>> OauthToken Saved to Storage")
        } catch {
            ErrorPrinterService.shared.printToConsole(error)
            preconditionFailure("Unable to save Token to Storage")
        }
    }
}
