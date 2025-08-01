//
//  UserDetailsEndpoint.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import Foundation

enum UserDetailsEndpoint {
    case getRepositories(username: String)
}

extension UserDetailsEndpoint: RequestProviding {
    var shouldAddAuthorization: Bool {
        true
    }
    
    var urlRequest: URLRequest {
        switch self {
        case .getRepositories(let username):
            guard let url = URL.getAPIURL(by: "/users/\(username)/repos") else { preconditionFailure() }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            return urlRequest
        }
    }
}
