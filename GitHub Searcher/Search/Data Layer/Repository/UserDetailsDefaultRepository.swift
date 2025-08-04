//
//  UserDetailsDefaultRepository.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Foundation
import Combine

final class UserDetailsDefaultRepository {
    private let remoteDataSource: UserDetailsRemoteDataSource
    
    init(remoteDataSource: UserDetailsRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
}

extension UserDetailsDefaultRepository: UserDetailsRepository {
    func getRepositories(by username: String) -> AnyPublisher<[RepositoryResponseModel], any Error> {
        remoteDataSource.getRepositories(by: username)
    }
}
