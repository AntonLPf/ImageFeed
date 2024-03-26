//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 23.02.24.
//

import Foundation

protocol ProfileImageServiceProtocol {
    var avatarUrl: String? { get }
    var didChangeNotificationName: Notification.Name { get }
    func fetchProfileImageURL(_ token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void)
    func reset()
}

extension ProfileImageServiceProtocol {
    var didChangeNotificationName: Notification.Name {
        Notification.Name(Constants.NCNotification.profileImageProviderDidChange)
    }
}

final class ProfileImageService: ProfileImageServiceProtocol {
    
    static let shared = ProfileImageService()
    
    private var ongoingTask: URLSessionTask?
    private let urlSession = URLSession.shared
    private let parser = DataParser()
    
    private(set) var avatarUrl: String?
    
    func fetchProfileImageURL(_ token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        ongoingTask?.cancel()
        
        guard let request = try? ProfileImageRequest.getUser(userName: username).createURLRequest(token: token) else {
            preconditionFailure("Invalid token request configuration")
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let userResult):
                if let profileImageUrl = userResult.profileImage?.medium {
                    self.avatarUrl = profileImageUrl
                    completion(.success(profileImageUrl))
                    NotificationCenter.default.post(
                        name: didChangeNotificationName,
                        object: self,
                        userInfo: ["URL": profileImageUrl])
                }
            case .failure(let error):
                ErrorPrinterService.shared.printToConsole(error)
                completion(.failure(error))
            }
        }
        self.ongoingTask = task
        task.resume()
    }
    
    func reset() {
        ongoingTask = nil
        avatarUrl = nil
    }
}
