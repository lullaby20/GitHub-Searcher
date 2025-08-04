//
//  SearchRemoteDataSource.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation
import Combine

protocol SearchRemoteDataSource {
    func getRepositories(by query: String, sortType: RepositoriesSortType, perPage: Int, page: Int) -> AnyPublisher<PaginatedGenericModel<RepositoryResponseModel>, Error>
    func getUsers(by query: String, perPage: Int, page: Int) -> AnyPublisher<PaginatedGenericModel<UserResponseModel>, Error>
}
