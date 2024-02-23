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
    
    private let requestManager = RequestManager()
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        let request = ProfileRequest.getProfile
        let queue = DispatchQueue(label: "com.unsplash.profileService.fetchProfile")
        queue.async {
            Task {
                print("HELLO")
                do {
                    let response: ProfileResult = try await self.requestManager.perform(request, token: token)
                    
                    let username = response.username
                    let name = "\(response.firstName) \(response.lastName)"
                    let loginName = "@\(username)"
                    let bio = response.bio ?? ""
                    
                    let profile = Profile(username: username, name: name, loginName: loginName, bio: bio)
                    self.profile = profile
                    completion(.success(profile))
                } catch {
                    assertionFailure("Could not get profile/n \(error)")
                    completion(.failure(error))
                }
            }
        }
    }
}
