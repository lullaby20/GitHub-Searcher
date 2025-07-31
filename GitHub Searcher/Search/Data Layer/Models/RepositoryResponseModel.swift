//
//  RepositoryResponseModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation

struct RepositoryResponseModel: Decodable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}

