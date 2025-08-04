//
//  UserDetailsRemoteDefaultDataSource.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import Foundation
import Combine

final class UserDetailsRemoteDefaultDataSource {
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
}

extension UserDetailsRemoteDefaultDataSource: UserDetailsRemoteDataSource {
    func getRepositories(by username: String) -> AnyPublisher<[RepositoryResponseModel], any Error> {
        network.execute(UserDetailsEndpoint.getRepositories(username: username))
    }
}
