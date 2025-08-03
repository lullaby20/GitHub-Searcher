//
//  ProfileDefaultRepositoryTests.swift
//  GitHub SearcherTests
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Testing
import Combine
import Foundation
@testable import GitHub_Searcher

struct ProfileDefaultRepositoryTests {
    var remoteDataSource: ProfileRemoteDataSource
    var repository: ProfileRepository
    
    init() {
        remoteDataSource = ProfileRemoteMockDataSource()
        repository = ProfileDefaultRepository(remoteDataSource: remoteDataSource)
    }
    
    @Test func testGetProfile() {
        var user: UserResponseModel?
        let cancellable = repository.getProfile()
            .sink(receiveCompletion: { _ in }, receiveValue: { user = $0 })
        RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        
        #expect(user?.id == 0)
        #expect(user?.login == "Mock User")
        #expect(user?.avatarUrlPath == "mockUrlPath")
    }
}
