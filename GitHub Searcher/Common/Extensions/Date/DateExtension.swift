//
//  DateExtension.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 01.08.2025.
//

import Foundation

extension Date {
    func toShortDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
