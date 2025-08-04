//
//  ProfileDefaultRepository.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Foundation
import Combine

final class ProfileDefaultRepository {
    private let remoteDataSource: ProfileRemoteDataSource
    
    init(remoteDataSource: ProfileRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
}

extension ProfileDefaultRepository: ProfileRepository {
    func getProfile() -> AnyPublisher<UserResponseModel, any Error> {
        remoteDataSource.getProfile()
    }
}
