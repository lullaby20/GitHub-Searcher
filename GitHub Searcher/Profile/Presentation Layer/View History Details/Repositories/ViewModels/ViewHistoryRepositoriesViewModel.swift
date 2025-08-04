//
//  ViewHistoryRepositoriesViewModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 03.08.2025.
//

import Foundation
import Combine

final class ViewHistoryRepositoriesViewModel: ObservableObject {
    typealias Dependencies = HasViewHistoryRepository
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    @Published var repositoriesViewModels: [RepositoryItemViewModel]
    
    var count: Int {
        repositoriesViewModels.count
    }
    
    init(dependencies: Dependencies) {
        repositoriesViewModels = dependencies.viewHistoryRepository.getRepositories().map { RepositoryItemViewModel(model: $0, viewHistoryRepository: dependencies.viewHistoryRepository) }
        
        dependencies.viewHistoryRepository.didChangeSubject
            .sink { [weak self] in
                guard let self else { return }
                self.repositoriesViewModels = dependencies.viewHistoryRepository.getRepositories().map { RepositoryItemViewModel(model: $0, viewHistoryRepository: dependencies.viewHistoryRepository) }
            }
            .store(in: &cancellables)
    }
}
