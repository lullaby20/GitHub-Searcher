//
//  SearchRepository.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation
import Combine

protocol SearchRepository {
    func getRepositories(by query: String) -> AnyPublisher<String, Error>
    func getUsers(by query: String) -> AnyPublisher<String, Error>
}
