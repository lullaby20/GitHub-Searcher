//
//  ViewHistoryRepository.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Foundation
import Combine

protocol ViewHistoryRepository {
    var didChangeSubject: PassthroughSubject<Void, Never> { get }
    
    func getRepositories() -> [RepositoryResponseModel]
    func getUsers() -> [UserResponseModel]
    
    func append(_ repository: RepositoryResponseModel)
    func append(_ user: UserResponseModel)
    
    func containsRepository(by id: Int) -> Bool
    func containsUser(by id: Int) -> Bool
    
    func clearAll()
}
