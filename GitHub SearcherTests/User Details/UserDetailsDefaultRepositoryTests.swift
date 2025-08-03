//
//  UserDetailsDefaultRepositoryTests.swift
//  GitHub SearcherTests
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Testing
import Combine
import Foundation
@testable import GitHub_Searcher

struct UserDetailsDefaultRepositoryTests {
    var remoteDataSource: UserDetailsRemoteDataSource
    var repository: UserDetailsRepository
    
    init() {
        remoteDataSource = UserDetailsRemoteMockDataSource()
        repository = UserDetailsDefaultRepository(remoteDataSource: remoteDataSource)
    }

    @Test func testGetRepositories() {
        var repositories: [RepositoryResponseModel] = []
        let cancellable = repository.getRepositories(by: "Mock User")
            .sink(receiveCompletion: { _ in }, receiveValue: { repositories = $0 })
        RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        
        #expect(repositories.count == 1)
        #expect(repositories.first?.id == 0)
        #expect(repositories.first?.name == "Mock Repository")
        
        if let mockRemote = remoteDataSource as? UserDetailsRemoteMockDataSource {
            #expect(mockRemote.receivedUsername == "Mock User")
        }
    }
}
    