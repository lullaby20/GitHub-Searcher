//
//  KeychainSecureMockStorage.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Foundation

final class KeychainSecureMockStorage: KeychainSecureStorage {
    private var storage: [KeychainSecureStorageKey: String] = [:]
    
    func set(value: String, for key: KeychainSecureStorageKey) {
        storage[key] = value
    }
    
    func getValue(for key: KeychainSecureStorageKey) -> String? {
        storage[key]
    }
    
    func removeValue(for key: KeychainSecureStorageKey) {
        storage.removeValue(forKey: key)
    }
}
