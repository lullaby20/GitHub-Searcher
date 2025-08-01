//
//  RequestProviding.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 01.08.2025.
//

import Foundation

protocol RequestProviding {
    var urlRequest: URLRequest { get }
    var shouldAddAuthorization: Bool { get }
}
