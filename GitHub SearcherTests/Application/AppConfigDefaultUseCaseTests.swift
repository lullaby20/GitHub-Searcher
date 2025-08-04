//
//  AppConfigDefaultUseCaseTests.swift
//  GitHub SearcherTests
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Testing
import Foundation
@testable import GitHub_Searcher

struct AppConfigDefaultUseCaseTests {
    var keychainSecureStorage: KeychainSecureStorage
    var userDefaultsStorage: UserDefaultsStorage
    var useCase: AppConfigUseCase
    
    init() {
        keychainSecureStorage = KeychainSecureMockStorage()
        userDefaultsStorage = UserDefaultsMockStorage()
        useCase = AppConfigDefaultUseCase(keychainSecureStorage: keychainSecureStorage, userDefaultsStorage: userDefaultsStorage)
    }

    @Test func testChangeAppStateToAuthorized() {
        useCase.changeAppState(to: .authorized)
        
        #expect(userDefaultsStorage.string(forKey: "AppStateRawKey") == AppState.authorized.rawValue)
        #expect(useCase.appStateSubject.value == .authorized)
    }

    @Test func testChangeAppStateToUnauthorized() {
        useCase.changeAppState(to: .unauthorized)
        
        #expect(userDefaultsStorage.string(forKey: "AppStateRawKey") == AppState.unauthorized.rawValue)
        #expect(useCase.appStateSubject.value == .unauthorized)
        #expect(keychainSecureStorage.getValue(for: .accessToken) == nil)
    }
}
