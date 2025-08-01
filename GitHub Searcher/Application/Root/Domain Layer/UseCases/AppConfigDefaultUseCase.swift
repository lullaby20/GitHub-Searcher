//
//  AppConfigDefaultUseCase.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import Foundation
import Combine

final class AppConfigDefaultUseCase: AppConfigUseCase {
    lazy var appStateSubject: CurrentValueSubject<AppState, Never> = {
        .init(loadAppState())
    }()
    
    func changeAppState(to newState: AppState) {
        UserDefaults.standard.set(newState.rawValue, forKey: "AppStateRawKey")
        appStateSubject.send(newState)
    }
}

fileprivate extension AppConfigDefaultUseCase {
    func loadAppState() -> AppState {
        if let rawValue = UserDefaults.standard.string(forKey: "AppStateRawKey"),
           let state = AppState(rawValue: rawValue) {
            return state
        }
        
        return .unauthorized
    }
}
