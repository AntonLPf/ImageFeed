//
//  UserResult.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 23.02.24.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: ProfileImage?
    
    struct ProfileImage: Decodable {
        let medium: String
    }
}
