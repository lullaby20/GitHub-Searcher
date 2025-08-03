//
//  ViewHistoryUsersViewModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 03.08.2025.
//

import Foundation

final class ViewHistoryUsersViewModel {
    typealias Dependencies = HasViewHistoryLocalDataSource
    
    let usersViewModel: [UserItemViewModel]
    
    init(dependencies: Dependencies) {
        self.usersViewModel = dependencies.viewHistoryLocalDataSource.getUsers().map { UserItemViewModel(model: $0, viewHistoryLocalDataSource: dependencies.viewHistoryLocalDataSource) }
    }
}
