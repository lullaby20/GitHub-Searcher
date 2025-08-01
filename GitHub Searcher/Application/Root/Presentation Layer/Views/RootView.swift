//
//  RootView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var viewModel: RootViewModel
    
    var body: some View {
        contentBodyView
            .animation(.easeOut(duration: 0.3), value: viewModel.appState)
    }
}

fileprivate extension RootView {
    @ViewBuilder
    var contentBodyView: some View {
        switch viewModel.appState {
        case .authorized:
            SearchView(viewModel: SearchViewModel(dependencies: viewModel.dependencies))
        case .unauthorized:
            AuthorizationView(viewModel: AuthorizationViewModel(dependencies: viewModel.dependencies))
        }
    }
}

#Preview {
    let mockDependencies: Dependencies = Dependencies()
    let mockViewModel = RootViewModel(dependencies: mockDependencies)
    
    RootView(viewModel: mockViewModel)
}
