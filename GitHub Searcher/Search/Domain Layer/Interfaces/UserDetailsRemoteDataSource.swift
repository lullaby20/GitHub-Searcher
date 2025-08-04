//
//  UserDetailsRemoteDataSource.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import Foundation
import Combine

protocol UserDetailsRemoteDataSource {
    func getRepositories(by username: String) -> AnyPublisher<[RepositoryResponseModel], Error>
}
