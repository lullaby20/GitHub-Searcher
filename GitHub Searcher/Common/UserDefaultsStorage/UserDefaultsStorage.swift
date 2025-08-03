//
//  UserDefaultsStorage.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 04.08.2025.
//

import Foundation

protocol UserDefaultsStorage {
    func string(forKey: String) -> String?
    func set(_ value: Any?, forKey: String)
}

extension UserDefaults: UserDefaultsStorage {}
