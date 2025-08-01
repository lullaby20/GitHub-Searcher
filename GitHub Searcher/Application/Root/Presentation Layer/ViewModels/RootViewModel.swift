//
//  RootViewModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import Foundation
import Combine

final class RootViewModel: ObservableObject {
    let dependencies: Dependencies
    
    private let appConfigUseCase: AppConfigUseCase
    private var cancellables: Set<AnyCancellable> = .init()
    
    @Published var appState: AppState
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.appConfigUseCase = dependencies.appConfigUseCase
        self._appState = Published(initialValue: appConfigUseCase.appStateSubject.value)
        
        bindAppState()
    }
}

fileprivate extension RootViewModel {
    func bindAppState() {
        appConfigUseCase.appStateSubject
            .sink { [weak self] state in
                guard let self else { return }
                self.appState = state
            }
            .store(in: &cancellables)
    }
}
