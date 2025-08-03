//
//  ViewHistoryRepositoriesViewModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 03.08.2025.
//

import Foundation
import Combine

final class ViewHistoryRepositoriesViewModel: ObservableObject {
    typealias Dependencies = HasViewHistoryLocalDataSource
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    @Published var repositoriesViewModels: [RepositoryItemViewModel]
    
    var count: Int {
        repositoriesViewModels.count
    }
    
    init(dependencies: Dependencies) {
        repositoriesViewModels = dependencies.viewHistoryLocalDataSource.getRepositories().map { RepositoryItemViewModel(model: $0, viewHistoryLocalDataSource: dependencies.viewHistoryLocalDataSource) }
        
        dependencies.viewHistoryLocalDataSource.didChangeSubject
            .sink { [weak self] in
                guard let self else { return }
                self.repositoriesViewModels = dependencies.viewHistoryLocalDataSource.getRepositories().map { RepositoryItemViewModel(model: $0, viewHistoryLocalDataSource: dependencies.viewHistoryLocalDataSource) }
            }
            .store(in: &cancellables)
    }
}
