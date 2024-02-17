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
    private let storage: KeyValueStorageProtocol
    private let tokenStorageKey: String
    
    var token: OAuthTokenResponseBody?
    
    private init(storage: KeyValueStorageProtocol = UserDefaultsManager()) {
        self.storage = storage
        self.tokenStorageKey = Constants.UserDefaultsKey.token.rawValue
        
        if let storedToken = try? storage.load(key: tokenStorageKey, OAuthTokenResponseBody.self) {
            self.token = storedToken
        } else {
            debugPrint(">>> Faied to load token. Need to authorise/reauthorise")
        }
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let requestManager = RequestManager()
        let request = TokenRequest.getToken(code: code)
        Task(priority: .userInitiated) {
            do {
                let token: OAuthTokenResponseBody = try await requestManager.perform(request)
                saveToStorage(token: token)
                completion(.success(token.accessToken))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func saveToStorage(token: OAuthTokenResponseBody) {
        do {
            try storage.save(codable: token, key: tokenStorageKey)
            debugPrint(">>> OauthToken Saved to Storage")
        } catch {
            fatalError("Unable to save Token to Storage") // TODO: убрать. Сделано на время дебага
        }
    }
}

extension OAuth2Service {
    private func object(for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
}

// MARK: - HTTP Request
extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode
            {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletion(.success(data))
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
}
