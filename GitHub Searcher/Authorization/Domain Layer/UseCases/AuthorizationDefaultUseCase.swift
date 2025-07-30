//
//  AuthorizationDefaultUseCase.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 29.07.2025.
//

import Foundation
import Combine

final class AuthorizationDefaultUseCase {
    private let repository: AuthorizationRepository
    
    var authorizationURLRequest: URLRequest {
        repository.authorizationURLRequest
    }
    
    init(repository: AuthorizationRepository) {
        self.repository = repository
    }
}

extension AuthorizationDefaultUseCase: AuthorizationUseCase {
    func getToken(from code: String) -> AnyPublisher<AuthorizationResponseModel, any Error> {
        repository.getToken(from: code)
    }
    
    func saveAccessToken(_ accessToken: String) {
        repository.saveAccessToken(accessToken)
    }
    
    func cleanAccessToken() {
        repository.cleanAccessToken()
    }
}
