//
//  PaginatedGenericModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation

struct PaginatedGenericModel<T: Decodable>: Decodable {
    let totalCount: Int
    let items: [T]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}
