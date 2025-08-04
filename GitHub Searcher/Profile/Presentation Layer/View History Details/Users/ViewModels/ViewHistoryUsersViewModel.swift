//
//  ViewHistoryUsersViewModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 03.08.2025.
//

import Foundation
import Combine

final class ViewHistoryUsersViewModel: ObservableObject {
    typealias Dependencies = HasViewHistoryRepository
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    @Published var usersViewModel: [UserItemViewModel]
    
    var count: Int {
        usersViewModel.count
    }
    
    init(dependencies: Dependencies) {
        self.usersViewModel = dependencies.viewHistoryRepository.getUsers().map { UserItemViewModel(model: $0, viewHistoryRepository: dependencies.viewHistoryRepository) }
        
        dependencies.viewHistoryRepository.didChangeSubject
            .sink { [weak self] in
                guard let self else { return }
                self.usersViewModel = dependencies.viewHistoryRepository.getUsers().map { UserItemViewModel(model: $0, viewHistoryRepository: dependencies.viewHistoryRepository) }
            }
            .store(in: &cancellables)
    }
}
