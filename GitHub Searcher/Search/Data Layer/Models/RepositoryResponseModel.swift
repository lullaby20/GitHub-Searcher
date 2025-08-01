//
//  RepositoryResponseModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation

struct RepositoryResponseModel: Decodable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let owner: UserResponseModel
    let updatedAt: Date
    let forksCount: Int
    let starsCount: Int
    let htmlUrlPath: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case owner
        case updatedAt = "updated_at"
        case forksCount = "forks"
        case starsCount = "stargazers_count"
        case htmlUrlPath = "html_url"
    }
}

extension RepositoryResponseModel: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: RepositoryResponseModel, rhs: RepositoryResponseModel) -> Bool {
        lhs.id == rhs.id
    }
}
