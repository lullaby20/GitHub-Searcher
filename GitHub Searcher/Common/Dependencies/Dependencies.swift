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

protocol HasUserDetailsRepository {
    var userDetailsRepository: UserDetailsRepository { get }
}

protocol HasProfileRepository {
    var profileRepository: ProfileRepository { get }
}

protocol HasViewHistoryRepository {
    var viewHistoryRepository: ViewHistoryRepository { get }
}

final class Dependencies:
    HasAppConfigUseCase,
    HasAuthorizationRepository,
    HasSearchRepository,
    HasUserDetailsRepository,
    HasProfileRepository,
    HasViewHistoryRepository {
    private let network: Networking
    private let keychainSecureStorage: KeychainSecureStorage
    
    lazy var appConfigUseCase: any AppConfigUseCase = {
        AppConfigDefaultUseCase(keychainSecureStorage: keychainSecureStorage)
    }()
    
    lazy var authorizationRepository: any AuthorizationRepository = {
        AuthorizationDefaultRepository(remoteDataSource: AuthorizationRemoteDefaultDataSource(network: network),
                                       keychainSecureStorage: keychainSecureStorage)
    }()
    
    lazy var searchRepository: any SearchRepository = {
        SearchDefaultRepository(remoteDataSource: SearchRemoteDefaultDataSource(network: network))
    }()
    
    lazy var userDetailsRepository: any UserDetailsRepository = {
        UserDetailsDefaultRepository(remoteDataSource: UserDetailsRemoteDefaultDataSource(network: network))
    }()
    
    lazy var profileRepository: any ProfileRepository = {
         ProfileDefaultRepository(remoteDataSource: ProfileRemoteDefaultDataSource(network: network))
    }()
    
    lazy var viewHistoryRepository: any ViewHistoryRepository = {
        ViewHistoryDefaultRepository(localDataSource: ViewHistoryLocalDefaultDataSource())
    }()
    
    init() {
        self.keychainSecureStorage = KeychainSecureDefaultStorage()
        self.network = Network(keychainSecureStorage: keychainSecureStorage)
    }
}
