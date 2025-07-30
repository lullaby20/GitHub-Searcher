//
//  RootView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import SwiftUI

struct RootView: View {
    let dependencies: Dependencies
    @AppStorage("AppStateRaw") private var appStateRaw: String = AppState.unAuthorized.rawValue
    
    // TODO: Refactor (Thinking about to move it all to AppConfigUseCase)
    private var appState: AppState {
        AppState(rawValue: appStateRaw) ?? .authorized
    }
    
    var body: some View {
        contentBodyView
            .animation(.easeOut(duration: 0.3), value: appStateRaw)
    }
}

fileprivate extension RootView {
    @ViewBuilder
    var contentBodyView: some View {
        switch appState {
        case .authorized:
            Text("Hi authorized")
            
            Button("Logout") {
                appStateRaw = AppState.unAuthorized.rawValue
            }
        case .unAuthorized:
            AuthorizationView(viewModel: AuthorizationViewModel(dependencies: dependencies))
        }
    }
}

#Preview {
    let mockDependencies: Dependencies = Dependencies()
    
    RootView(dependencies: mockDependencies)
}
