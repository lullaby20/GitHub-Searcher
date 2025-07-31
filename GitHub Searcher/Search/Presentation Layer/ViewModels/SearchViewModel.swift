//
//  SearchViewModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    typealias Dependencies = HasSearchRepository
    
    private let repository: SearchRepository
    private var cancellables: Set<AnyCancellable> = .init()
    
    @Published var searchingContentType: SearchingContentType = .repositories
    
    @Published var repositoriesSearchText: String = ""
    @Published var repositories: [RepositoryResponseModel] = []
    
    @Published var usersSearchText: String = ""
    @Published var users: [UserResponseModel] = []
    
    @Published var isLoadingPagination: Bool = false
    @Published var alert: Alert?
    
    init(dependencies: Dependencies) {
        self.repository = dependencies.searchRepository
        
        bindSearchTexts()
    }
}

// MARK: - Repositories
extension SearchViewModel {
    func getRepositories(by query: String) {
        repository.getRepositories(by: query)
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
                guard let self else { return }
                self.repositories = repositories
            }
            .store(in: &cancellables)
    }
    
    func getMoreRepositories(after model: RepositoryResponseModel) {
        guard model.id == repositories.last?.id, !isLoadingPagination else { return }
        
        isLoadingPagination = true
        
        repository.getMoreRepositories(by: repositoriesSearchText)
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
                self.repositories += repositories
            }
            .store(in: &cancellables)
    }
}

extension SearchViewModel {
    func getUsers(by query: String) {
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
                guard let self else { return }
                self.users = users
            }
            .store(in: &cancellables)
    }
    
    func getMoreUsers(after model: UserResponseModel) {
        guard model.id == users.last?.id, !isLoadingPagination else { return }
        
        isLoadingPagination = true
        
        repository.getMoreUsers(by: usersSearchText)
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
                self.users += users
            }
            .store(in: &cancellables)
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
}

fileprivate extension SearchViewModel {
    func bindSearchTexts() {
        $repositoriesSearchText
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let self, !newValue.isEmpty else { return }
                self.getRepositories(by: newValue)
            }
            .store(in: &cancellables)
        
        $usersSearchText
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                guard let self, !newValue.isEmpty else { return }
                self.getUsers(by: newValue)
            }
            .store(in: &cancellables)
    }
}
