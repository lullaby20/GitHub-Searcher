//
//  AuthorizationUseCase.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 29.07.2025.
//

import Foundation
import Combine

protocol AuthorizationUseCase {
    var authorizationURLRequest: URLRequest { get }
    
    func getToken(from code: String) -> AnyPublisher<AuthorizationResponseModel, Error>
    func saveAccessToken(_ accessToken: String)
    func cleanAccessToken()
}
