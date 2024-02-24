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
        
        let task = urlSession.objectTask(for: request) { (result: Result<UserResult, Error>) in
            switch result {
            case .success(let userResult):
                let profileImageUrl = userResult.profileImage.small
                self.avatarUrl = profileImageUrl
                completion(.success(profileImageUrl))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": profileImageUrl])
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.ongoingTask = task
        task.resume()
    }
}
