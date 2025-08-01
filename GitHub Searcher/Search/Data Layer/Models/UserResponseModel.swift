//
//  UserResponseModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation

struct UserResponseModel: Decodable, Identifiable {
    let id: Int
    let login: String
    let avatarUrlPath: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrlPath = "avatar_url"
    }
}

extension UserResponseModel: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UserResponseModel, rhs: UserResponseModel) -> Bool {
        lhs.id == rhs.id
    }
}
