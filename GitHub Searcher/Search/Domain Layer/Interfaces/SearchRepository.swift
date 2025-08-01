//
//  SearchRepository.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation
import Combine

protocol SearchRepository {
    func getRepositories(by query: String, sortType: RepositoriesSortType) -> AnyPublisher<[RepositoryResponseModel], Error>
    func getMoreRepositories(by query: String, sortType: RepositoriesSortType) -> AnyPublisher<[RepositoryResponseModel], Error>
    
    func getUsers(by query: String) -> AnyPublisher<[UserResponseModel], Error>
    func getMoreUsers(by query: String) -> AnyPublisher<[UserResponseModel], Error>
}
