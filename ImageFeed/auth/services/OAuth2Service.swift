//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 12.02.24.
//

import Foundation
import SwiftKeychainWrapper

protocol OAuth2ServiceProtocol {
    var token: String? { get }
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void)
}

final class OAuth2Service: OAuth2ServiceProtocol {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private let tokenStorageKey: String
    
    var token: String? {
        didSet {
            if let token {
                saveToStorage(token: token)
            }
        }
    }
    
    private init() {
        self.tokenStorageKey = Constants.UserDefaultsKey.token.rawValue
        
        if let storedToken = KeychainWrapper.standard.string(forKey: tokenStorageKey) {
            debugPrint(">>> Found stored auth token. User Authorized")
            self.token = storedToken
        } else {
            debugPrint(">>> Faied to load token. Need to authorise/reauthorized")
        }
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else { return }
        task?.cancel()
        lastCode = code
        
        guard let request = try? TokenRequest.getToken(code: code).createURLRequest(token: nil) else {
            let error = NetworkError.invalidRequest
            ErrorPrinterService.shared.printToConsole(error)
            completion(.failure(error))
            preconditionFailure("Invalid token request configuration")
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            switch result {
            case .success(let token):
                let bearerAccessToken = token.bearerAccessToken
                self.token = bearerAccessToken
                completion(.success(bearerAccessToken))
            case .failure(let error):
                ErrorPrinterService.shared.printToConsole(error)
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func saveToStorage(token: String) {
        let isSuccess = KeychainWrapper.standard.set(token, forKey: tokenStorageKey)
        guard isSuccess else {
            preconditionFailure("Unable to save Token to Storage")
        }
        debugPrint(">>> OauthToken Saved to Storage")
    }
}
