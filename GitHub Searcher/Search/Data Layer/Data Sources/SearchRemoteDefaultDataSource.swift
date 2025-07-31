//
//  SearchRemoteDefaultDataSource.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation
import Combine

final class SearchRemoteDefaultDataSource {
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
}

extension SearchRemoteDefaultDataSource: SearchRemoteDataSource {
    func getRepositories(by query: String) -> AnyPublisher<PaginatedGenericModel<RepositoryResponseModel>, any Error> {
        network.executeURLRequest(SearchEndpoint.searchRepositories(query: query).urlRequest)
    }
    
    func getUsers(by query: String) -> AnyPublisher<PaginatedGenericModel<UserResponseModel>, any Error> {
        network.executeURLRequest(SearchEndpoint.searchUsers(query: query).urlRequest)
    }
}
