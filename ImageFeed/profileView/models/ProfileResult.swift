//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Антон Шишкин on 23.02.24.
//

import Foundation

struct ProfileResult: Decodable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
}
