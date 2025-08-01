//
//  AppConfigUseCase.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import Foundation
import Combine

protocol AppConfigUseCase {
    var appStateSubject: CurrentValueSubject<AppState, Never> { get }
    
    func changeAppState(to newState: AppState)
}
