//
//  ViewHistoryLocalMockDataSource.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Foundation
import OrderedCollections
import Combine

final class ViewHistoryLocalMockDataSource: ViewHistoryLocalDataSource {
    private var repositories: OrderedSet<RepositoryResponseModel> = []
    private var users: OrderedSet<UserResponseModel> = []
    
    var didChangeSubject: PassthroughSubject<Void, Never> = .init()
    
    func getRepositories() -> [RepositoryResponseModel] {
        Array(repositories)
    }
    
    func getUsers() -> [UserResponseModel] {
        Array(users)
    }
    
    func append(_ repository: RepositoryResponseModel) {
        if repositories.count == 20 {
            repositories.removeFirst()
        }
        
        repositories.append(repository)
        didChangeSubject.send()
    }
    
    func append(_ user: UserResponseModel) {
        if users.count == 20 {
            users.removeFirst()
        }
        
        users.append(user)
        didChangeSubject.send()
    }
    
    func containsRepository(by id: Int) -> Bool {
        repositories.contains(where: { $0.id == id })
    }
    
    func containsUser(by id: Int) -> Bool {
        users.contains(where: { $0.id == id })
    }
    
    func clearAll() {
        repositories.removeAll()
        users.removeAll()
        didChangeSubject.send()
    }
}
