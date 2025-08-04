//
//  ProfileEndpoint.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import Foundation

enum ProfileEndpoint {
    case getProfile
}

extension ProfileEndpoint: RequestProviding {
    var shouldAddAuthorization: Bool {
        true
    }
    
    var urlRequest: URLRequest {
        switch self {
        case .getProfile:
            guard let url = URL.getAPIURL(by: "/user") else { preconditionFailure() }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            return urlRequest
        }
    }
}
