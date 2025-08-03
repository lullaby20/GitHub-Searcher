//
//  ViewHistoryDefaultRepository.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Foundation
import Combine

final class ViewHistoryDefaultRepository {
    private let localDataSource: ViewHistoryLocalDataSource
    
    let didChangeSubject: PassthroughSubject<Void, Never>
    
    init(localDataSource: ViewHistoryLocalDataSource) {
        self.localDataSource = localDataSource
        self.didChangeSubject = localDataSource.didChangeSubject
    }
}

extension ViewHistoryDefaultRepository: ViewHistoryRepository {
    func getRepositories() -> [RepositoryResponseModel] {
        localDataSource.getRepositories()
    }
    
    func getUsers() -> [UserResponseModel] {
        localDataSource.getUsers()
    }
    
    func append(_ repository: RepositoryResponseModel) {
        localDataSource.append(repository)
    }
    
    func append(_ user: UserResponseModel) {
        localDataSource.append(user)
    }
    
    func containsRepository(by id: Int) -> Bool {
        localDataSource.containsRepository(by: id)
    }
    
    func containsUser(by id: Int) -> Bool {
        localDataSource.containsUser(by: id)
    }
    
    func clearAll() {
        localDataSource.clearAll()
    }
}
