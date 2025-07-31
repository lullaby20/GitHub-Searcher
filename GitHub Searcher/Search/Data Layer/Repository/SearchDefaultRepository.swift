//
//  SearchDefaultRepository.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation
import Combine

final class SearchDefaultRepository {
    private let remoteDataSource: SearchRemoteDataSource
    private var currentCount: Int = 30
    private var currentPage: Int = 1
    private var totalCount: Int = 0
    
    init(remoteDataSource: SearchRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
}

extension SearchDefaultRepository: SearchRepository {
    // MARK: - Repositories
    func getRepositories(by query: String) -> AnyPublisher<[RepositoryResponseModel], any Error> {
        remoteDataSource.getRepositories(by: query)
            .tryMap {
                self.totalCount = $0.totalCount
                
                return $0.items
            }
            .eraseToAnyPublisher()
    }
    
    func getMoreRepositories(by query: String) -> AnyPublisher<[RepositoryResponseModel], any Error> {
        guard currentCount < totalCount else {
            return Empty()
                .eraseToAnyPublisher()
        }
        
        return remoteDataSource.getRepositories(by: query)
            .tryMap {
                self.totalCount = $0.totalCount
                self.currentPage += 1
                self.currentCount += 30
                
                return $0.items
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Users
    func getUsers(by query: String) -> AnyPublisher<[UserResponseModel], any Error> {
        remoteDataSource.getUsers(by: query)
            .tryMap {
                self.totalCount = $0.totalCount
                
                return $0.items
            }
            .eraseToAnyPublisher()
    }
    
    func getMoreUsers(by query: String) -> AnyPublisher<[UserResponseModel], any Error> {
        guard currentCount < totalCount else {
            return Empty()
                .eraseToAnyPublisher()
        }
        
        return remoteDataSource.getUsers(by: query)
            .tryMap {
                self.totalCount = $0.totalCount
                self.currentPage += 1
                self.currentCount += 30
                
                return $0.items
            }
            .eraseToAnyPublisher()
    }
}
