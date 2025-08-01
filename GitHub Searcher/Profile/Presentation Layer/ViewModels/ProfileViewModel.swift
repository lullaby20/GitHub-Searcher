//
//  ProfileViewModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject {
    private let dependencies: Dependencies
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}
