//
//  ViewHistoryRepositoriesView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 03.08.2025.
//

import SwiftUI

struct ViewHistoryRepositoriesView: View {
    @ObservedObject var viewModel: ViewHistoryRepositoriesViewModel
    
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
                countView
                    .padding(.bottom, 5)
                
                ForEach(viewModel.repositoriesViewModels.reversed()) { repositoryViewModel in
                    RepositoryItemView(viewModel: repositoryViewModel)
                }
            }
            .padding(.bottom, 16)
        }
    }
    
    var countView: some View {
        Text("Count: \(viewModel.count)")
            .font(.callout)
            .fontWeight(.medium)
            .fontDesign(.rounded)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
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
