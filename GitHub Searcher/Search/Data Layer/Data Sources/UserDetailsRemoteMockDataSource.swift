//
//  UserDetailsRemoteMockDataSource.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Foundation
import Combine

final class UserDetailsRemoteMockDataSource: UserDetailsRemoteDataSource {
    var receivedUsername: String?
    var result: AnyPublisher<[RepositoryResponseModel], any Error> =
        Just([RepositoryResponseModel(id: 0,
                                      name: "Mock Repository",
                                      description: "Mock Repository",
                                      owner: UserResponseModel(id: 0, login: "Mock User", avatarUrlPath: "mockUrlPath"),
                                      updatedAt: Date(timeIntervalSince1970: TimeInterval(10)),
                                      forksCount: 10,
                                      starsCount: 10,
                                      htmlUrlPath: "mockUrlPath")])
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    
    func getRepositories(by username: String) -> AnyPublisher<[RepositoryResponseModel], any Error> {
        receivedUsername = username
        return result
    }
}
