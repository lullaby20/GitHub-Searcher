//
//  AuthorizationDefaultRepository.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 29.07.2025.
//

import Foundation
import Combine

final class AuthorizationDefaultRepository {
    private let remoteDataSource: AuthorizationRemoteDataSource
    private let keychainSecureStorage: KeychainSecureStorage
    
    private var clientID: String {
        keychainSecureStorage.getValue(for: .clientID) ?? ""
    }
    
    private var clientSecret: String {
        keychainSecureStorage.getValue(for: .clientSecret) ?? ""
    }
    
    private var redirectURI: String {
        keychainSecureStorage.getValue(for: .redirectURI) ?? ""
    }
    
    var authorizationURLRequest: URLRequest {
        AuthorizationEndpoint.authorization(clientID: clientID, redirectURI: redirectURI).urlRequest
    }
    
    init(remoteDataSource: AuthorizationRemoteDataSource,
         keychainSecureStorage: KeychainSecureStorage) {
        self.remoteDataSource = remoteDataSource
        self.keychainSecureStorage = keychainSecureStorage
    }
}

extension AuthorizationDefaultRepository: AuthorizationRepository {
    func getToken(from code: String) -> AnyPublisher<AuthorizationResponseModel, any Error> {
        remoteDataSource.getToken(from: code,
                                  clientID: clientID,
                                  clientSecret: clientSecret,
                                  redirectURI: redirectURI)
    }
    
    func saveAccessToken(_ accessToken: String) {
        keychainSecureStorage.set(value: accessToken, for: .accessToken)
    }
    
    func cleanAccessToken() {
        keychainSecureStorage.removeValue(for: .accessToken)
    }
}

