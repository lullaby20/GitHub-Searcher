//
//  SearchViewModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}
