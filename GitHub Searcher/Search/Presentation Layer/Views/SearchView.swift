//
//  SearchView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    @State private var navigationPath = NavigationPath()
    
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
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 8) {
                pickerView
                    .padding(.horizontal, 16)
                
                List {
                    switch viewModel.searchingContentType {
                    case .repositories:
                        repositoriesView
                    case .users:
                        usersView
                    }
                }
            }
            .searchable(text: searchTextBinding, prompt: "Start typing...")
            .safeAreaInset(edge: .bottom) {
                if viewModel.isLoadingPagination {
                    ProgressView()
                        .frame(width: 24, height: 24)
                        .progressViewStyle(.circular)
                }
            }
        }
    }
    
    var pickerView: some View {
        Picker("Searching content type", selection: $viewModel.searchingContentType) {
            ForEach(SearchingContentType.allCases, id: \.self) { searchType in
                Text(searchType.title)
            }
        }
        .pickerStyle(.segmented)
    }
    
    var repositoriesView: some View {
        ForEach(viewModel.repositories) { repository in
            RepositoryItemView(model: repository)
                .onAppear {
                    viewModel.getMoreRepositories(after: repository)
                }
        }
    }
    
    var usersView: some View {
        ForEach(viewModel.users) { user in
            Text(user.login)
                .onAppear {
                    viewModel.getMoreUsers(after: user)
                }
        }
    }
}

fileprivate extension SearchView {
    var searchTextBinding: Binding<String> {
        switch viewModel.searchingContentType {
        case .repositories:
            return $viewModel.repositoriesSearchText
        case .users:
            return $viewModel.usersSearchText
        }
    }
}

#Preview {
    let mockDependencies: Dependencies = Dependencies()
    
    SearchView(viewModel: SearchViewModel(dependencies: mockDependencies))
}
