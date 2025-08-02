//
//  ViewHistoryLocalDataSource.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import Foundation

protocol ViewHistoryLocalDataSource {
    func getRepositories() -> [RepositoryResponseModel]
    func getUsers() -> [UserResponseModel]
    
    func append(_ repository: RepositoryResponseModel)
    func append(_ user: UserResponseModel)
    
    func clearAll()
}
