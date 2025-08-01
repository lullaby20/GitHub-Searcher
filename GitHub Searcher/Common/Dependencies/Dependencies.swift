//
//  Dependencies.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 30.07.2025.
//

import Foundation

protocol HasAppConfigUseCase {
    var appConfigUseCase: AppConfigUseCase { get }
}

protocol HasAuthorizationRepository {
    var authorizationRepository: AuthorizationRepository { get }
}

protocol HasSearchRepository {
    var searchRepository: SearchRepository { get }
}

protocol HasUserDetailsRemoteDataSource {
    var userDetailsRemoteDataSource: UserDetailsRemoteDataSource { get }
}

final class Dependencies:
    HasAppConfigUseCase,
    HasAuthorizationRepository,
    HasSearchRepository,
    HasUserDetailsRemoteDataSource {
    private let network: Networking
    private let keychainSecureStorage: KeychainSecureStorage
    
    lazy var appConfigUseCase: any AppConfigUseCase = {
       return AppConfigDefaultUseCase()
    }()
    
    lazy var authorizationRepository: any AuthorizationRepository = {
        return AuthorizationDefaultRepository(remoteDataSource: AuthorizationRemoteDefaultDataSource(network: network),
                                              keychainSecureStorage: keychainSecureStorage)
    }()
    
    lazy var searchRepository: any SearchRepository = {
        return SearchDefaultRepository(remoteDataSource: SearchRemoteDefaultDataSource(network: network))
    }()
    
    lazy var userDetailsRemoteDataSource: any UserDetailsRemoteDataSource = {
        return UserDetailsRemoteDefaultDataSource(network: network)
    }()
    
    init() {
        self.keychainSecureStorage = KeychainSecureDefaultStorage()
        self.network = Network(keychainSecureStorage: keychainSecureStorage)
    }
}
