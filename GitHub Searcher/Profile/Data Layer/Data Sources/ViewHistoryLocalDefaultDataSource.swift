//
//  ViewHistoryLocalDefaultDataSource.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import Foundation
import OrderedCollections
import Combine

final class ViewHistoryLocalDefaultDataSource: ViewHistoryLocalDataSource {
    private let repositoriesKey = "repositoriesKey"
    private let usersKey = "usersKey"
    
    private var repositories: OrderedSet<RepositoryResponseModel> {
        get {
            guard let data = UserDefaults.standard.data(forKey: repositoriesKey),
                  let decodedData = try? JSONDecoder().decode(OrderedSet<RepositoryResponseModel>.self, from: data) else {
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
    
    private var users: OrderedSet<UserResponseModel> {
        get {
            guard let data = UserDefaults.standard.data(forKey: usersKey),
                  let decodedData = try? JSONDecoder().decode(OrderedSet<UserResponseModel>.self, from: data) else {
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
    
    let didChangeSubject: PassthroughSubject<Void, Never> = .init()
    
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
