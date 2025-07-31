//
//  SearchEndpoint.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation

enum SearchEndpoint {
    case searchRepositories(query: String, perPage: Int, page: Int)
    case searchUsers(query: String)
}

extension SearchEndpoint {
    var urlRequest: URLRequest {
        switch self {
        case .searchRepositories(let query, let perPage, let page):
            guard let url = URL.getAPIURL(by: "/search/repositories") else { preconditionFailure() }
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            
            var queryItems: [URLQueryItem] = []
            queryItems.append(URLQueryItem(name: "q", value: query))
            queryItems.append(URLQueryItem(name: "per_page", value: "\(perPage)"))
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
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
