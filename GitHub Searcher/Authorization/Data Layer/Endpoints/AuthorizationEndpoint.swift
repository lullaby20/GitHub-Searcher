//
//  AuthorizationEndpoint.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 29.07.2025.
//

import Foundation

enum AuthorizationEndpoint {
    case getToken(code: String,
                  clientID: String,
                  clientSecret: String,
                  redirectURI: String)
    case authorization(clientID: String, redirectURI: String)
}

extension AuthorizationEndpoint {
    var urlRequest: URLRequest {
        switch self {
        case .getToken(let code, let clientID, let clientSecret, let redirectURI):
            guard let url = URL(string: "https://github.com/login/oauth/access_token") else { preconditionFailure() }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            
            let body = "client_id=\(clientID)&client_secret=\(clientSecret)&code=\(code)&redirect_uri=\(redirectURI)"
            urlRequest.httpBody = body.data(using: .utf8)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
            
            return urlRequest
        case .authorization(let clientID, let redirectURI):
            guard let url = URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientID)&redirect_uri=\(redirectURI)") else { preconditionFailure() }
            return URLRequest(url: url)
        }
    }
}
