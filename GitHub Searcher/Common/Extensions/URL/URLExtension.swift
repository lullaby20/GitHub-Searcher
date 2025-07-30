//
//  URLExtension.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation

extension URL {
    static func getAPIURL(by path: String) -> URL? {
        URL(string: "https://api.github.com" + path)
    }
}
