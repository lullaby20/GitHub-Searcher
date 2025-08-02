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
    
    private var repositories: [RepositoryResponseModel] {
        get {
            guard let data = UserDefaults.standard.data(forKey: repositoriesKey),
                  let decodedData = try? JSONDecoder().decode([RepositoryResponseModel].self, from: data) else {
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
    
    private var users: [UserResponseModel] {
        get {
            guard let data = UserDefaults.standard.data(forKey: usersKey),
                  let decodedData = try? JSONDecoder().decode([UserResponseModel].self, from: data) else {
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
        repositories
    }
    
    func getUsers() -> [UserResponseModel] {
        users
    }
    
    func append(_ repository: RepositoryResponseModel) {
        if repositories.count >= 30 {
            repositories.removeFirst()
        }
        
        repositories.append(repository)
    }
    
    func append(_ user: UserResponseModel) {
        if users.count >= 30 {
            users.removeFirst()
        }
        
        users.append(user)
    }
    
    func clearAll() {
        repositories.removeAll()
        users.removeAll()
    }
}
