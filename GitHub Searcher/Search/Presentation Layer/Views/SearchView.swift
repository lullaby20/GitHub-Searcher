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
                
                ScrollView(showsIndicators: false) {
                    stateView
                }
            }
            .padding(.horizontal, 16)
            .searchable(text: $viewModel.searchText, prompt: "Start typing...")
            .onSubmit(of: .search) {
                viewModel.configureState()
            }
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
}

fileprivate extension SearchView {
    @ViewBuilder
    var stateView: some View {
        switch viewModel.state {
        case .empty:
            emptyView
        case .loading:
            loadingView
        case .results:
            resultsView
        case .notFound:
            notFoundView
        }
    }
    
    @ViewBuilder
    var loadingView: some View {
        VStack(spacing: 5) {
            switch viewModel.searchingContentType {
            case .repositories:
                repositoriesSortTypeView
                
                ForEach(0..<6) { _ in
                    RepositoryItemLoadingView()
                }
            case .users:
                ForEach(0..<6) { _ in
                    UserItemLoadingView()
                }
            }
        }
    }
    
    @ViewBuilder
    var resultsView: some View {
        LazyVStack(spacing: 5) {
            switch viewModel.searchingContentType {
            case .repositories:
                repositoriesSortTypeView
                
                ForEach(viewModel.repositories) { repository in
                    RepositoryItemView(model: repository)
                        .onAppear {
                            viewModel.getMoreRepositories(after: repository)
                        }
                }
            case .users:
                ForEach(viewModel.users) { user in
                    UserItemView(model: user)
                        .onAppear {
                            viewModel.getMoreUsers(after: user)
                        }
                }
            }
        }
    }
    
    var repositoriesSortTypeView: some View {
        HStack(spacing: 0) {
            Text("Sort by:")
            
            Picker("Sort", selection: $viewModel.repositoriesSortType) {
                ForEach(RepositoriesSortType.allCases, id: \.self) { sortType in
                    Text(sortType.presentationName)
                }
            }
            .pickerStyle(.menu)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    var emptyView: some View {
        ContentUnavailableView("Start typing what you're looking for...",
                               systemImage: "magnifyingglass")
    }
    
    var notFoundView: some View {
        ContentUnavailableView.search(text: viewModel.searchText)
    }
}

#Preview {
    let mockDependencies: Dependencies = Dependencies()
    
    SearchView(viewModel: SearchViewModel(dependencies: mockDependencies))
}
