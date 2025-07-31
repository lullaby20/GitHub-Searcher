//
//  RepositoryResponseModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation

struct RepositoryResponseModel: Decodable, Identifiable {
    let name: String
    let id = UUID()
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}

