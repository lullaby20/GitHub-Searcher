//
//  AuthorizationRemoteDataSource.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 29.07.2025.
//

import Foundation
import Combine

protocol AuthorizationRemoteDataSource {
    func getToken(from code: String,
                  clientID: String,
                  clientSecret: String,
                  redirectURI: String) -> AnyPublisher<AuthorizationResponseModel, Error>
}
