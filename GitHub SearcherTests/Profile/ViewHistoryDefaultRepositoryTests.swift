//
//  ViewHistoryDefaultRepositoryTests.swift
//  GitHub SearcherTests
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Testing
import Foundation
import Combine
@testable import GitHub_Searcher

struct ViewHistoryDefaultRepositoryTests {
    var localDataSource: ViewHistoryLocalDataSource
    var repository: ViewHistoryRepository
    
    init() {
        localDataSource = ViewHistoryLocalMockDataSource()
        repository = ViewHistoryDefaultRepository(localDataSource: localDataSource)
    }

    // MARK: - Append and Contains
    @Test func testAppendAndContainsRepository() {
        let mockRepo = RepositoryResponseModel(id: 0,
                                               name: "Mock Repository",
                                               description: "Mock Repository",
                                               owner: UserResponseModel(id: 0, login: "Mock User", avatarUrlPath: "mockUrlPath"),
                                               updatedAt: Date(timeIntervalSince1970: TimeInterval(10)),
                                               forksCount: 10,
                                               starsCount: 10,
                                               htmlUrlPath: "mockUrlPath")
        repository.append(mockRepo)
        let storedRepos = repository.getRepositories()
        
        #expect(storedRepos.contains(where: { $0.id == mockRepo.id }))
        #expect(repository.containsRepository(by: mockRepo.id))
    }
    
    @Test func testAppendAndContainsUser() {
        let mockUser = UserResponseModel(id: 0, login: "Mock User", avatarUrlPath: "mockUrlPath")
        repository.append(mockUser)
        let storedUsers = repository.getUsers()
        
        #expect(storedUsers.contains(where: { $0.id == mockUser.id }))
        #expect(repository.containsUser(by: mockUser.id))
    }
    
    @Test func testDidChangeSubjectSends() async {
        var didReceive = false
        let cancellable = repository.didChangeSubject
            .sink {
                didReceive = true
            }
        
        let mockRepo = RepositoryResponseModel(id: 0,
                                               name: "Mock Repository",
                                               description: "Mock Repository",
                                               owner: UserResponseModel(id: 0, login: "Mock User", avatarUrlPath: "mockUrlPath"),
                                               updatedAt: Date(timeIntervalSince1970: TimeInterval(10)),
                                               forksCount: 10,
                                               starsCount: 10,
                                               htmlUrlPath: "mockUrlPath")
        repository.append(mockRepo)
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        #expect(didReceive)
        
        _ = cancellable
    }
    
    // MARK: - Limit Reach
    @Test func testLimitReachRepositories() {
        for i in 1...21 {
            let mockRepo = RepositoryResponseModel(id: i,
                                                   name: "Mock Repository \(i)",
                                                   description: "Mock Repository \(i)",
                                                   owner: UserResponseModel(id: i, login: "Mock User \(i)", avatarUrlPath: "mockUrlPath"),
                                                   updatedAt: Date(timeIntervalSince1970: TimeInterval(10)),
                                                   forksCount: 10,
                                                   starsCount: 10,
                                                   htmlUrlPath: "mockUrlPath")
            repository.append(mockRepo)
        }
        
        let storedRepos = repository.getRepositories()
        
        #expect(storedRepos.count == 20)
        #expect(!storedRepos.contains(where: { $0.id == 1 }))
        #expect(storedRepos.contains(where: { $0.id == 21 }))
    }
    
    @Test func testLimitReachUsers() {
        for i in 1...21 {
            let mockUser = UserResponseModel(id: i, login: "Mock User \(i)", avatarUrlPath: "mockUrlPath")
            repository.append(mockUser)
        }
        
        let storedUsers = repository.getUsers()
        
        #expect(storedUsers.count == 20)
        #expect(!storedUsers.contains(where: { $0.id == 1 }))
        #expect(storedUsers.contains(where: { $0.id == 21 }))
    }
    
    // MARK: - Clear all
    @Test func testClearAll() {
        repository.clearAll()
        
        #expect(repository.getRepositories().isEmpty)
        #expect(repository.getUsers().isEmpty)
    }
}
