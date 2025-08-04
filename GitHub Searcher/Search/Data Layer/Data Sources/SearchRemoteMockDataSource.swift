//
//  SearchRemoteMockDataSource.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Foundation
import Combine

final class SearchRemoteMockDataSource: SearchRemoteDataSource {
    var receivedQuery: String?
    var receivedPerPage: Int?
    var receivedPage: Int?
    var receivedRepoSortType: RepositoriesSortType?
    
    var reposResult: AnyPublisher<PaginatedGenericModel<RepositoryResponseModel>, any Error> =
        Just(PaginatedGenericModel(totalCount: 35, items: [RepositoryResponseModel(id: 0,
                                                                                   name: "Mock Repository",
                                                                                   description: "Mock Repository",
                                                                                   owner: UserResponseModel(id: 0, login: "Mock User", avatarUrlPath: "mockUrlPath"),
                                                                                   updatedAt: Date(timeIntervalSince1970: TimeInterval(10)),
                                                                                   forksCount: 10,
                                                                                   starsCount: 10,
                                                                                   htmlUrlPath: "mockUrlPath")]))
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    
    var usersResult: AnyPublisher<PaginatedGenericModel<UserResponseModel>, any Error> =
        Just(PaginatedGenericModel(totalCount: 35, items: [UserResponseModel(id: 0, login: "Mock user", avatarUrlPath: "mockUrlPath")]))
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    
    func getRepositories(by query: String, sortType: RepositoriesSortType, perPage: Int, page: Int) -> AnyPublisher<PaginatedGenericModel<RepositoryResponseModel>, any Error> {
        receivedQuery = query
        receivedRepoSortType = sortType
        receivedPerPage = perPage
        receivedPage = page
        
        return reposResult
    }
    
    func getUsers(by query: String, perPage: Int, page: Int) -> AnyPublisher<PaginatedGenericModel<UserResponseModel>, any Error> {
        receivedQuery = query
        receivedPerPage = perPage
        receivedPage = page
        
        return usersResult
    }
}
