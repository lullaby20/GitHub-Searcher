//
//  AuthorizationRemoteMockDataSource.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Foundation
import Combine

final class AuthorizationRemoteMockDataSource: AuthorizationRemoteDataSource {
    var receivedCode: String?
    var receivedClientID: String?
    var receivedClientSecret: String?
    var receivedRedirectURI: String?
    var tokenResult: AnyPublisher<AuthorizationResponseModel, any Error> =
        Just(AuthorizationResponseModel(accessToken: "mock-token"))
        .setFailureType(to: Error.self)
        .eraseToAnyPublisher()

    func getToken(from code: String,
                  clientID: String,
                  clientSecret: String,
                  redirectURI: String) -> AnyPublisher<AuthorizationResponseModel, any Error> {
        self.receivedCode = code
        self.receivedClientID = clientID
        self.receivedClientSecret = clientSecret
        self.receivedRedirectURI = redirectURI
        return tokenResult
    }
}
