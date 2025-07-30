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
    
    init(remoteDataSource: SearchRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
}

extension SearchDefaultRepository: SearchRepository {
    func getRepositories(by query: String) -> AnyPublisher<String, any Error> {
        remoteDataSource.getRepositories(by: query)
    }
    
    func getUsers(by query: String) -> AnyPublisher<String, any Error> {
        remoteDataSource.getUsers(by: query)
    }
}
