//
//  ViewHistoryLocalDefaultDataSource.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import Foundation

final class ViewHistoryLocalDefaultDataSource: ViewHistoryLocalDataSource {
    private let repositoriesKey = "repositoriesKey"
    private let usersKey = "usersKey"
    
    private var repositories: Set<RepositoryResponseModel> {
        get {
            guard let data = UserDefaults.standard.data(forKey: repositoriesKey),
                  let decodedData = try? JSONDecoder().decode(Set<RepositoryResponseModel>.self, from: data) else {
                return []
            }
            
            return decodedData
        }
        
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedData, forKey: repositoriesKey)
            }
        }
    }
    
    private var users: Set<UserResponseModel> {
        get {
            guard let data = UserDefaults.standard.data(forKey: usersKey),
                  let decodedData = try? JSONDecoder().decode(Set<UserResponseModel>.self, from: data) else {
                return []
            }
            
            return decodedData
        }
        
        set {
            if let encodedData = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encodedData, forKey: usersKey)
            }
        }
    }
    
    func getRepositories() -> [RepositoryResponseModel] {
        Array(repositories)
    }
    
    func getUsers() -> [UserResponseModel] {
        Array(users)
    }
    
    func append(_ repository: RepositoryResponseModel) {
        if repositories.count >= 20 {
            repositories.removeFirst()
        }
        
        repositories.insert(repository)
    }
    
    func append(_ user: UserResponseModel) {
        if users.count >= 20 {
            users.removeFirst()
        }
        
        users.insert(user)
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
    }
}
