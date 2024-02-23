//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 23.02.24.
//

import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void)
}

final class ProfileService: ProfileServiceProtocol {
    static let shared = ProfileService()
    
    private init() {}
    
    private(set) var profile: Profile?
    private var ongoingTask: URLSessionTask?
    
    private let urlSession = URLSession.shared
    private let parser = DataParser()
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        ongoingTask?.cancel()
        
        guard let request = try? ProfileRequest.getProfile.createURLRequest(token: token) else {
            preconditionFailure("Invalid token request configuration")
        }

        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
            } else if let httpResponse = response as? HTTPURLResponse {
                
                let statusCode = httpResponse.statusCode
                
                switch statusCode {
                case 200..<300:
                    guard
                        let data,
                        let profileResult: ProfileResult = try? self.parser.parse(data: data)
                    else {
                        let error = NetworkError.parsingError
                        completion(.failure(error))
                        return
                    }
                    
                    let username = profileResult.username
                    let name = "\(profileResult.firstName) \(profileResult.lastName)"
                    let loginName = "@\(username)"
                    let bio = profileResult.bio ?? ""
                    
                    let profile = Profile(username: username, name: name, loginName: loginName, bio: bio)
                    self.profile = profile
                    completion(.success(profile))
                default:
                    
                    completion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            }
            self.ongoingTask = nil
        }
        self.ongoingTask = task
        task.resume()
    }
}
