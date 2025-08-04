//
//  KeychainSecureStorage.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 30.07.2025.
//

import Foundation
import SwiftKeychainWrapper

protocol KeychainSecureStorage {
    func set(value: String, for key: KeychainSecureStorageKey)
    func getValue(for key: KeychainSecureStorageKey) -> String?
    func removeValue(for key: KeychainSecureStorageKey)
}

enum KeychainSecureStorageKey: String {
    case clientID
    case clientSecret
    case redirectURI
    case accessToken
}

final class KeychainSecureDefaultStorage: KeychainSecureStorage {
    init() {
        KeychainWrapper.standard.set("Ov23liq1AqnmIs0e84y4", forKey: KeychainSecureStorageKey.clientID.rawValue)
        KeychainWrapper.standard.set("df45b29778955ccdcf3681ba57b0332c989c4167", forKey: KeychainSecureStorageKey.clientSecret.rawValue)
        KeychainWrapper.standard.set("githubsearcher://callback", forKey: KeychainSecureStorageKey.redirectURI.rawValue)
    }
    
    func set(value: String, for key: KeychainSecureStorageKey) {
        KeychainWrapper.standard.set(value, forKey: key.rawValue)
    }
    
    func getValue(for key: KeychainSecureStorageKey) -> String? {
        KeychainWrapper.standard.string(forKey: key.rawValue)
    }
    
    func removeValue(for key: KeychainSecureStorageKey) {
        KeychainWrapper.standard.removeObject(forKey: key.rawValue)
    }
}
