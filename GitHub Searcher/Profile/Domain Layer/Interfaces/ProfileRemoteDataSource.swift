//
//  ProfileRemoteDataSource.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import Foundation
import Combine

protocol ProfileRemoteDataSource {
    func getProfile() -> AnyPublisher<UserResponseModel, Error>
}
