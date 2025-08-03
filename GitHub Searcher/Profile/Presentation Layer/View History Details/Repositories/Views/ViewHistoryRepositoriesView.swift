//
//  ViewHistoryRepositoriesView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 03.08.2025.
//

import SwiftUI

struct ViewHistoryRepositoriesView: View {
    let viewModel: ViewHistoryRepositoriesViewModel
    
    var body: some View {
        contentBodyView
            .padding(.horizontal, 16)
            .navigationTitle("Viewed Repositories")
    }
}

fileprivate extension ViewHistoryRepositoriesView {
    @ViewBuilder
    var contentBodyView: some View {
        if viewModel.repositoriesViewModels.isEmpty {
            emptyView
        } else {
            repositoriesListView
        }
    }
    
    var repositoriesListView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 5) {
                ForEach(viewModel.repositoriesViewModels) { repositoryViewModel in
                    RepositoryItemView(viewModel: repositoryViewModel)
                }
            }
            .padding(.bottom, 16)
        }
    }
    
    var emptyView: some View {
        ContentUnavailableView("No Viewed Repositories",
                               systemImage: "magnifyingglass",
                               description: Text("Repositories you view will appear here."))
    }
}

#Preview {
    let mockDependencies = Dependencies()
    let mockViewModel = ViewHistoryRepositoriesViewModel(dependencies: mockDependencies)
    
    ViewHistoryRepositoriesView(viewModel: mockViewModel)
}
