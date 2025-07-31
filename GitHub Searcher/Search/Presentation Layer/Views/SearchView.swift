//
//  SearchView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        contentBodyView
            .alert(item: $viewModel.alert) { alert in
                switch alert {
                case .error:
                    Alert(title: Text(alert.title),
                          message: Text(alert.message),
                          dismissButton: .cancel(Text(alert.dismissButtonTitle)))
                }
            }
    }
}

fileprivate extension SearchView {
    var contentBodyView: some View {
        NavigationStack {
            List {
                ForEach(viewModel.repositories) { repository in
                    Text(repository.name)
                        .onAppear {
                            viewModel.getMoreRepositories(after: repository)
                        }
                }
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Start typing...")
            .safeAreaInset(edge: .bottom) {
                if viewModel.isLoadingPagination {
                    ProgressView()
                        .frame(width: 24, height: 24)
                        .progressViewStyle(.circular)
                }
            }
        }
    }
}

#Preview {
    let mockDependencies: Dependencies = Dependencies()
    
    SearchView(viewModel: SearchViewModel(dependencies: mockDependencies))
}
