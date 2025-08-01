//
//  RepositoriesSortType.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 01.08.2025.
//

import Foundation

enum RepositoriesSortType: String, CaseIterable {
    case stars
    case updated
    case forks
    
    var presentationName: String {
        switch self {
        case .stars:
            "Stars"
        case .updated:
            "Updated Date"
        case .forks:
            "Forks"
        }
    }
}
