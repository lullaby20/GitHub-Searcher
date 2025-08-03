//
//  ProfileRemoteMockDataSource.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Foundation
import Combine

final class ProfileRemoteMockDataSource: ProfileRemoteDataSource {
    var result: AnyPublisher<UserResponseModel, any Error> =
        Just(UserResponseModel(id: 0, login: "Mock User", avatarUrlPath: "mockUrlPath"))
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()
    
    func getProfile() -> AnyPublisher<UserResponseModel, any Error> {
        result
    }
}
