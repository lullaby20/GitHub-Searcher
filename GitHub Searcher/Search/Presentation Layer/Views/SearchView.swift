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
            .onReceive(viewModel.userViewModelTapped) { model in
                navigationPath.append(model)
            }
            .alert(item: $viewModel.alert) { alert in
                switch alert {
                case .error:
                    Alert(title: Text(alert.title),
                          message: Text(alert.message),
                          dismissButton: .cancel(Text(alert.dismissButtonTitle)))
                }
            }
            .sheet(item: $viewModel.sheet, onDismiss: { [unowned viewModel] in
                viewModel.sheet = nil
            }) { sheet in
                switch sheet {
                case .safari(let url):
                    SafariView(url: url)
                }
            }
    }
}

fileprivate extension SearchView {
    var contentBodyView: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 8) {
                contentTypePickerView
                
                ScrollView(showsIndicators: false) {
                    stateView
                }
                .scrollDismissesKeyboard(.immediately)
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
            .navigationTitle("GitHub Searcher")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: UserResponseModel.self) { user in
                UserDetailsView(viewModel: viewModel.makeUserDetailsViewModel(for: user))
            }
        }
    }
    
    var contentTypePickerView: some View {
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
                repositoriesSortTypePickerView
                
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
                repositoriesSortTypePickerView
                
                ForEach(viewModel.repositoriesViewModels) { repositoryViewModel in
                    RepositoryItemView(viewModel: repositoryViewModel)
                        .onAppear {
                            viewModel.getMoreRepositories(after: repositoryViewModel)
                        }
                }
            case .users:
                ForEach(viewModel.usersViewModels) { userViewModel in
                    UserItemView(viewModel: userViewModel)
                        .onAppear {
                            viewModel.getMoreUsers(after: userViewModel)
                        }
                }
            }
        }
        .padding(.bottom, 16)
    }
    
    var repositoriesSortTypePickerView: some View {
        HStack(spacing: 0) {
            Text("Sort by:")
                .fontDesign(.rounded)
            
            Picker("Sort", selection: $viewModel.repositoriesSortType) {
                ForEach(RepositoriesSortType.allCases, id: \.self) { sortType in
                    Text(sortType.presentationName)
                        .fontDesign(.rounded)
                }
            }
            .pickerStyle(.menu)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    var emptyView: some View {
        ContentUnavailableView("Search",
                               systemImage: "magnifyingglass",
                               description: Text("Start typing what you're searching for..."))
    }
    
    var notFoundView: some View {
        ContentUnavailableView.search(text: viewModel.searchText)
    }
}

#Preview {
    let mockDependencies: Dependencies = Dependencies()
    
    SearchView(viewModel: SearchViewModel(dependencies: mockDependencies))
}
