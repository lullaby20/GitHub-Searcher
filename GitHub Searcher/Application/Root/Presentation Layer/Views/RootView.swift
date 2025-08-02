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
            TabView(selection: $viewModel.selectedTabIndex) {
                SearchView(viewModel: viewModel.searchViewModel)
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                    .tag(0)
                
                ProfileView(viewModel: viewModel.profileViewModel)
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle.fill")
                    }
                    .tag(1)
            }
        case .unauthorized:
            AuthorizationView(viewModel: viewModel.authorizationViewModel)
        }
    }
}

#Preview {
    let mockDependencies: Dependencies = Dependencies()
    let mockViewModel = RootViewModel(dependencies: mockDependencies)
    
    RootView(viewModel: mockViewModel)
}
