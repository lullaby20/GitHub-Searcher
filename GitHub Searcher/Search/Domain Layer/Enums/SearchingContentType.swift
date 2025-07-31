//
//  SearchingContentType.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation

enum SearchingContentType: CaseIterable {
    case repositories
    case users
    
    var title: String {
        switch self {
        case .repositories:
            "Repositories"
        case .users:
            "Users"
        }
    }
}
