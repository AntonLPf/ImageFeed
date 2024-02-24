//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 23.02.24.
//

import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    private init() {}
    
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private var ongoingTask: URLSessionTask?
    private let urlSession = URLSession.shared
    private let parser = DataParser()
    
    private(set) var avatarUrl: String?
    
    
    func fetchProfileImageURL(_ token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        ongoingTask?.cancel()
        
        guard let request = try? ProfileImageRequest.getUser(userName: username).createURLRequest(token: token) else {
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
                        let userResult: UserResult = try? self.parser.parse(data: data)
                    else {
                        let error = NetworkError.parsingError
                        completion(.failure(error))
                        return
                    }
                    let profileImageUrl = userResult.profileImage.small
                    self.avatarUrl = profileImageUrl
                    completion(.success(profileImageUrl))
                    NotificationCenter.default.post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImageUrl])
                default:
                    debugPrint("FAILED TO GET IMAGE URL")
                    debugPrint(statusCode)
                    completion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            }
            self.ongoingTask = nil
        }
        self.ongoingTask = task
        task.resume()
    }
}
