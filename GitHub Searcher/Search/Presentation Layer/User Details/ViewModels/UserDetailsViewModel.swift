//
//  UserDetailsViewModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import Foundation
import Combine

final class UserDetailsViewModel: ObservableObject {
    typealias Dependencies =
        HasUserDetailsRemoteDataSource &
        HasViewHistoryLocalDataSource
    
    enum RepositoriesState {
        case loading
        case content
        case empty
        case failure
    }
    
    private let model: UserResponseModel
    private let dependencies: Dependencies
    private let remoteDataSource: UserDetailsRemoteDataSource
    
    private(set) var repositoriesViewModels: [RepositoryItemViewModel] = []
    private var cancellables: Set<AnyCancellable> = .init()
    
    @Published var repositoriesState: RepositoriesState = .loading
    @Published var sheet: Sheet?
    
    var avatarUrl: URL? {
        URL(string: model.avatarUrlPath)
    }
    
    var name: String {
        model.login
    }
    
    init(model: UserResponseModel,
         dependencies: Dependencies) {
        self.model = model
        self.dependencies = dependencies
        self.remoteDataSource = dependencies.userDetailsRemoteDataSource
    }
}

extension UserDetailsViewModel {
    func getRepositories() {
        repositoriesState = .loading
        
        remoteDataSource.getRepositories(by: name)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                switch status {
                case .finished:
                    self.repositoriesState = .content
                case .failure(let error):
                    self.repositoriesState = .failure
                }
            } receiveValue: { [weak self] repositories in
                guard let self, !repositories.isEmpty else {
                    self?.repositoriesState = .empty
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
            }
            .store(in: &cancellables)
    }
}

extension UserDetailsViewModel {
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
