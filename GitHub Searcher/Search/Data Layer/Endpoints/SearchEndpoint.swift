//
//  SearchEndpoint.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation

enum SearchEndpoint {
    case searchRepositories(query: String)
    case searchUsers(query: String)
}

extension SearchEndpoint {
    var urlRequest: URLRequest {
        switch self {
        case .searchRepositories(let query):
            guard let url = URL.getAPIURL(by: "/search/repositories") else { preconditionFailure() }
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            var queryItems: [URLQueryItem] = []
            queryItems.append(URLQueryItem(name: "q", value: query))
            urlComponents?.queryItems = queryItems
            
            guard let urlComponentsURL = urlComponents?.url else { preconditionFailure() }
            var urlRequest = URLRequest(url: urlComponentsURL)
            urlRequest.httpMethod = "GET"
            return urlRequest
        case .searchUsers(let query):
            guard let url = URL.getAPIURL(by: "/search/users") else { preconditionFailure() }
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            var queryItems: [URLQueryItem] = []
            queryItems.append(URLQueryItem(name: "q", value: query))
            urlComponents?.queryItems = queryItems
            
            guard let urlComponentsURL = urlComponents?.url else { preconditionFailure() }
            var urlRequest = URLRequest(url: urlComponentsURL)
            urlRequest.httpMethod = "GET"
            return urlRequest
        }
    }
}
