//
//  SearchRemoteDataSource.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation
import Combine

protocol SearchRemoteDataSource {
    func getRepositories(by query: String) -> AnyPublisher<PaginatedGenericModel<RepositoryResponseModel>, Error>
    func getUsers(by query: String) -> AnyPublisher<PaginatedGenericModel<UserResponseModel>, Error>
}
