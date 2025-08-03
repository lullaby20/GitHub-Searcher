//
//  SearchDefaultRepositoryTests.swift
//  GitHub SearcherTests
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Testing
import Combine
import Foundation
@testable import GitHub_Searcher

struct SearchDefaultRepositoryTests {
    var remoteDataSource: SearchRemoteDataSource
    var repository: SearchRepository
    
    init() {
        remoteDataSource = SearchRemoteMockDataSource()
        repository = SearchDefaultRepository(remoteDataSource: remoteDataSource)
    }

    // MARK: - Get First Page
    @Test func testGetFirstPageOfRepositories() {
        var repositories: [RepositoryResponseModel] = []
        let cancellable = repository.getRepositories(by: "testQuery", sortType: .stars)
            .sink(receiveCompletion: { _ in }, receiveValue: { repositories = $0 })
        RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        
        if let mockRemote = remoteDataSource as? SearchRemoteMockDataSource {
            #expect(repositories.count == 1)
            #expect(mockRemote.receivedQuery == "testQuery")
            #expect(mockRemote.receivedPage == 1)
        }
    }
    
    @Test func testGetFirstPageOfUsers() {
        var users: [UserResponseModel] = []
        let cancellable = repository.getUsers(by: "testQuery")
            .sink(receiveCompletion: { _ in }, receiveValue: { users = $0 })
        RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        
        if let mockRemote = remoteDataSource as? SearchRemoteMockDataSource {
            #expect(users.count == 1)
            #expect(mockRemote.receivedQuery == "testQuery")
            #expect(mockRemote.receivedPage == 1)
        }
    }
    
    // MARK: - Get Second Page
    @Test func testGetSecondPageOfRepositories() {
        var repositories: [RepositoryResponseModel] = []
        let firstCancellable = repository.getRepositories(by: "testQuery", sortType: .stars)
            .sink(receiveCompletion: { _ in }, receiveValue: { repositories = $0 })
        RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        
        let secondCancellable = repository.getMoreRepositories(by: "testQuery", sortType: .stars)
            .sink(receiveCompletion: { _ in }, receiveValue: { repositories += $0 })
        RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        
        if let mockRemote = remoteDataSource as? SearchRemoteMockDataSource {
            #expect(repositories.count == 2)
            #expect(mockRemote.receivedQuery == "testQuery")
            #expect(mockRemote.receivedPage == 2)
        }
    }
    
    @Test func testGetSecondPageOfUsers() {
        var users: [UserResponseModel] = []
        let firstCancellable = repository.getUsers(by: "testQuery")
            .sink(receiveCompletion: { _ in }, receiveValue: { users = $0 })
        RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        
        let secondCancellable = repository.getMoreUsers(by: "testQuery")
            .sink(receiveCompletion: { _ in }, receiveValue: { users += $0 })
        RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        
        if let mockRemote = remoteDataSource as? SearchRemoteMockDataSource {
            #expect(users.count == 2)
            #expect(mockRemote.receivedQuery == "testQuery")
            #expect(mockRemote.receivedPage == 2)
        }
    }
}
