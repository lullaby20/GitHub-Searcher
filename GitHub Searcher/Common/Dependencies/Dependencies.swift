//
//  Dependencies.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 30.07.2025.
//

import Foundation

protocol HasAuthorizationUseCase {
    var authorizationUseCase: AuthorizationUseCase { get }
}

protocol HasSearchRepository {
    var searchRepository: SearchRepository { get }
}

final class Dependencies:
    HasAuthorizationUseCase,
    HasSearchRepository {
    private let network: Networking
    private let keychainSecureStorage: KeychainSecureStorage
    
    lazy var authorizationUseCase: any AuthorizationUseCase = {
        let repository = AuthorizationDefaultRepository(remoteDataSource: AuthorizationRemoteDefaultDataSource(network: network),
                                                        keychainSecureStorage: keychainSecureStorage)
        return AuthorizationDefaultUseCase(repository: repository)
    }()
    
    lazy var searchRepository: any SearchRepository = {
        return SearchDefaultRepository(remoteDataSource: SearchRemoteDefaultDataSource(network: network))
    }()
    
    init() {
        self.keychainSecureStorage = KeychainSecureDefaultStorage()
        self.network = Network(keychainSecureStorage: keychainSecureStorage)
    }
}
