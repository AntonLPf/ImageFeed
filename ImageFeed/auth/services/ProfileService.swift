//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 23.02.24.
//

import Foundation

final class ProfileService {
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
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let profileResult):
                let profile = self.convert(profileResult)
                self.profile = profile
                completion(.success(profile))
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
        profile = nil
    }
    
    private func convert(_ profileResult: ProfileResult) -> Profile {
        let username = profileResult.username
        var name = profileResult.firstName ?? ""
        if let lastName = profileResult.lastName {
            name += " \(lastName)"
        }
        let loginName = "@\(username)"
        let bio = profileResult.bio ?? ""
        
        return Profile(username: username, name: name, loginName: loginName, bio: bio)
    }
}
