//
//  AuthorizationDefaultRepositoryTests.swift
//  GitHub SearcherTests
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Testing
import Combine
import Foundation
@testable import GitHub_Searcher

struct AuthorizationDefaultRepositoryTests {
    var keychainSecureStorage: KeychainSecureStorage
    var remoteDataSource: AuthorizationRemoteDataSource
    var repository: AuthorizationRepository
    
    init() {
        keychainSecureStorage = KeychainSecureMockStorage()
        remoteDataSource = AuthorizationRemoteMockDataSource()
        repository = AuthorizationDefaultRepository(remoteDataSource: remoteDataSource, keychainSecureStorage: keychainSecureStorage)
    }
    
    @Test func testAuthorizationURLRequestContainsCorrectParams() {
        keychainSecureStorage.set(value: "client", for: .clientID)
        keychainSecureStorage.set(value: "redirectURI", for: .redirectURI)
        
        let url = repository.authorizationURLRequest.url?.absoluteString ?? ""
        #expect(url.contains("client_id=client"))
        #expect(url.contains("redirect_uri=redirectURI"))
    }
    
    @Test func testGetTokenCallsRemoteWithCorrectValue() {
        keychainSecureStorage.set(value: "client", for: .clientID)
        keychainSecureStorage.set(value: "secret", for: .clientSecret)
        keychainSecureStorage.set(value: "redirectURI", for: .redirectURI)
        
        var accessToken: String?
        let cancellable = repository.getToken(from: "123")
            .sink(receiveCompletion: { _ in }, receiveValue: { accessToken = $0.accessToken })
        RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        
        #expect(accessToken == "mock-token")
        
        if let mockRemote = remoteDataSource as? AuthorizationRemoteMockDataSource {
            #expect(mockRemote.receivedCode == "123")
            #expect(mockRemote.receivedClientID == "client")
            #expect(mockRemote.receivedClientSecret == "secret")
            #expect(mockRemote.receivedRedirectURI == "redirectURI")
        }
    }
    
    @Test func testSaveAccessToken() {
        repository.saveAccessToken("mockedToken")
        #expect(keychainSecureStorage.getValue(for: .accessToken) == "mockedToken")
    }
    
    @Test func testCleanAccessToken() {
        repository.cleanAccessToken()
        #expect(keychainSecureStorage.getValue(for: .accessToken) == nil)
    }
}
