//
//  UserDefaultsMockStorage.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Foundation

final class UserDefaultsMockStorage: UserDefaultsStorage {
    private var storage: [String: Any] = [:]
    
    func string(forKey key: String) -> String? {
        return storage[key] as? String
    }
    
    func set(_ value: Any?, forKey key: String) {
        storage[key] = value
    }
}
