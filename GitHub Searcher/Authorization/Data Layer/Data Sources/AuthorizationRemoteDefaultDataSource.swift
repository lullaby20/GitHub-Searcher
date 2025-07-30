//
//  AuthorizationRemoteDefaultDataSource.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 29.07.2025.
//

import Foundation
import Combine

final class AuthorizationRemoteDefaultDataSource {
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
}

extension AuthorizationRemoteDefaultDataSource: AuthorizationRemoteDataSource {
    func getToken(from code: String,
                  clientID: String,
                  clientSecret: String,
                  redirectURI: String) -> AnyPublisher<AuthorizationResponseModel, any Error> {
        network.executeURLRequest(AuthorizationEndpoint.getToken(code: code,
                                                                 clientID: clientID,
                                                                 clientSecret: clientSecret,
                                                                 redirectURI: redirectURI).urlRequest)
    }
}
