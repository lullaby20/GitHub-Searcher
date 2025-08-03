//
//  SearchViewModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    typealias Dependencies =
        HasSearchRepository &
        HasUserDetailsRemoteDataSource &
        HasViewHistoryLocalDataSource
    
    enum State {
        case empty
        case loading
        case results
        case notFound
    }
    
    private let dependencies: Dependencies
    private let repository: SearchRepository
    private var cancellables: Set<AnyCancellable> = .init()
    
    private(set) var repositoriesViewModels: [RepositoryItemViewModel] = []
    private(set) var usersViewModels: [UserItemViewModel] = []
    
    let userViewModelTapped: PassthroughSubject<UserResponseModel, Never> = .init()
    
    @Published var state: State = .empty
    @Published var searchText: String = ""
    @Published var searchingContentType: SearchingContentType = .repositories
    @Published var repositoriesSortType: RepositoriesSortType = .stars
    @Published var isLoadingPagination: Bool = false
    @Published var alert: Alert?
    @Published var sheet: Sheet?
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.repository = dependencies.searchRepository
        
        bindSearchText()
        bindSearchingContentType()
        bindRepositoriesSortType()
    }
}

extension SearchViewModel {
    func configureState() {
        guard state != .loading else { return }
        
        if searchText.isEmpty {
            self.state = .empty
            return
        }
        
        switch searchingContentType {
        case .repositories:
            self.getRepositories(by: searchText)
        case .users:
            self.getUsers(by: searchText)
        }
    }
}

// MARK: - Repositories
extension SearchViewModel {
    func getRepositories(by query: String) {
        state = .loading
        
        repository.getRepositories(by: query, sortType: repositoriesSortType)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                switch status {
                case .finished:
                    return
                case .failure(let error):
                    self.alert = .error(message: error.localizedDescription)
                }
            } receiveValue: { [weak self] repositories in
                guard let self, !repositories.isEmpty else {
                    self?.state = .notFound
                    return
                }
                self.repositoriesViewModels = repositories.map {
                    let viewModel = RepositoryItemViewModel(model: $0, viewHistoryLocalDataSource: self.dependencies.viewHistoryLocalDataSource)
                    
                    viewModel.onTapSubject
                        .sink { [weak self] url in
                            guard let self else { return }
                            self.sheet = .safari(url: url)
                        }
                        .store(in: &self.cancellables)
                    
                    return viewModel
                }
                self.state = .results
            }
            .store(in: &cancellables)
    }
    
    func getMoreRepositories(after viewModel: RepositoryItemViewModel) {
        guard viewModel.id == repositoriesViewModels.last?.id, !isLoadingPagination else { return }
        
        isLoadingPagination = true
        
        repository.getMoreRepositories(by: searchText, sortType: repositoriesSortType)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                self.isLoadingPagination = false
                switch status {
                case .finished:
                    return
                case .failure(let error):
                    self.alert = .error(message: error.localizedDescription)
                }
            } receiveValue: { [weak self] repositories in
                guard let self else { return }
                self.repositoriesViewModels += repositories.map {
                    let viewModel = RepositoryItemViewModel(model: $0, viewHistoryLocalDataSource: self.dependencies.viewHistoryLocalDataSource)
                    
                    viewModel.onTapSubject
                        .sink { [weak self] url in
                            guard let self else { return }
                            self.sheet = .safari(url: url)
                        }
                        .store(in: &self.cancellables)
                    
                    return viewModel
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Users
extension SearchViewModel {
    func getUsers(by query: String) {
        state = .loading
        
        repository.getUsers(by: query)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                switch status {
                case .finished:
                    return
                case .failure(let error):
                    self.alert = .error(message: error.localizedDescription)
                }
            } receiveValue: { [weak self] users in
                guard let self, !users.isEmpty else {
                    self?.state = .notFound
                    return
                }
                self.usersViewModels = users.map {
                    let viewModel = UserItemViewModel(model: $0, viewHistoryLocalDataSource: self.dependencies.viewHistoryLocalDataSource)
                    
                    viewModel.onTapSubject
                        .sink { [weak self] model in
                            guard let self else { return }
                            self.userViewModelTapped.send(model)
                        }
                        .store(in: &self.cancellables)
                    
                    return viewModel
                }
                self.state = .results
            }
            .store(in: &cancellables)
    }
    
    func getMoreUsers(after viewModel: UserItemViewModel) {
        guard viewModel.id == usersViewModels.last?.id, !isLoadingPagination else { return }
        
        isLoadingPagination = true
        
        repository.getMoreUsers(by: searchText)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                self.isLoadingPagination = false
                switch status {
                case .finished:
                    return
                case .failure(let error):
                    self.alert = .error(message: error.localizedDescription)
                }
            } receiveValue: { [weak self] users in
                guard let self else { return }
                self.usersViewModels += users.map {
                    let viewModel = UserItemViewModel(model: $0, viewHistoryLocalDataSource: self.dependencies.viewHistoryLocalDataSource)
                    
                    viewModel.onTapSubject
                        .sink { [weak self] model in
                            guard let self else { return }
                            self.userViewModelTapped.send(model)
                        }
                        .store(in: &self.cancellables)
                    
                    return viewModel
                }
            }
            .store(in: &cancellables)
    }
    
    func makeUserDetailsViewModel(for user: UserResponseModel) -> UserDetailsViewModel {
        UserDetailsViewModel(model: user, dependencies: dependencies)
    }
}

extension SearchViewModel {
    enum Alert: Identifiable {
        case error(message: String)
        
        var title: String {
            switch self {
            case .error:
                "Oops..."
            }
        }
        
        var message: String {
            switch self {
            case .error(let message):
                message
            }
        }
        
        var dismissButtonTitle: String {
            switch self {
            case .error:
                "OK"
            }
        }
        
        var id: String {
            switch self {
            case .error:
                "error"
            }
        }
    }
    
    enum Sheet: Identifiable {
        case safari(url: URL)
        
        var id: String {
            switch self {
            case .safari:
                "safari"
            }
        }
    }
}

fileprivate extension SearchViewModel {
    func bindSearchText() {
        $searchText
            .dropFirst()
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let self else { return }
                self.configureState()
            }
            .store(in: &cancellables)
    }
    
    func bindSearchingContentType() {
        $searchingContentType
            .dropFirst()
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let self else { return }
                self.configureState()
            }
            .store(in: &cancellables)
    }
    
    func bindRepositoriesSortType() {
        $repositoriesSortType
            .dropFirst()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let self else { return }
                self.getRepositories(by: searchText)
            }
            .store(in: &cancellables)
    }
}
