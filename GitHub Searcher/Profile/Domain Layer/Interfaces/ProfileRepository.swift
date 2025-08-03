//
//  ProfileRepository.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Foundation
import Combine

protocol ProfileRepository {
    func getProfile() -> AnyPublisher<UserResponseModel, Error>
}
