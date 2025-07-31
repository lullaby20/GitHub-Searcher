//
//  RepositoryResponseModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation

struct RepositoryResponseModel: Decodable, Identifiable {
    let id = UUID()
    let name: String
    let description: String?
    let owner: UserResponseModel
    let updatedAt: Date
    let forksCount: Int
    let starsCount: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case owner
        case updatedAt = "updated_at"
        case forksCount = "forks"
        case starsCount = "stargazers_count"
    }
}

