//
//  ProfileRemoteDefaultDataSource.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import Foundation
import Combine

final class ProfileRemoteDefaultDataSource {
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
}

extension ProfileRemoteDefaultDataSource: ProfileRemoteDataSource {
    func getProfile() -> AnyPublisher<UserResponseModel, any Error> {
        network.execute(ProfileEndpoint.getProfile)
    }
}
