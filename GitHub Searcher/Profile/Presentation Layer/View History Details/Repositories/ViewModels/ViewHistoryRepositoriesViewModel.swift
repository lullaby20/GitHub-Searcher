//
//  ViewHistoryRepositoriesViewModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 03.08.2025.
//

import Foundation

final class ViewHistoryRepositoriesViewModel {
    typealias Dependencies = HasViewHistoryLocalDataSource
    
    let repositoriesViewModels: [RepositoryItemViewModel]
    
    init(dependencies: Dependencies) {
        repositoriesViewModels = dependencies.viewHistoryLocalDataSource.getRepositories().map { RepositoryItemViewModel(model: $0, viewHistoryLocalDataSource: dependencies.viewHistoryLocalDataSource) }
    }
}
