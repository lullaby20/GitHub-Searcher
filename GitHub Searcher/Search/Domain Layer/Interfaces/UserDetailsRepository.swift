//
//  UserDetailsRepository.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Foundation
import Combine

protocol UserDetailsRepository {
    func getRepositories(by username: String) -> AnyPublisher<[RepositoryResponseModel], Error>
}
