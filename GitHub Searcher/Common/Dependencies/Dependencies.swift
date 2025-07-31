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

protocol HasKeychainSecureStorage {
    var keychainSecureStorage: KeychainSecureStorage { get }
}

protocol HasSearchRepository {
    var searchRepository: SearchRepository { get }
}

final class Dependencies:
    HasAuthorizationUseCase,
    HasKeychainSecureStorage,
    HasSearchRepository {
    private let network: Networking
    
    lazy var authorizationUseCase: any AuthorizationUseCase = {
        let repository = AuthorizationDefaultRepository(remoteDataSource: AuthorizationRemoteDefaultDataSource(network: network),
                                                        keychainSecureStorage: keychainSecureStorage)
        return AuthorizationDefaultUseCase(repository: repository)
    }()
    
    lazy var keychainSecureStorage: any KeychainSecureStorage = {
        return KeychainSecureDefaultStorage()
    }()
    
    lazy var searchRepository: any SearchRepository = {
        return SearchDefaultRepository(remoteDataSource: SearchRemoteDefaultDataSource(network: network))
    }()
    
    init() {
        self.network = Network()
    }
}
