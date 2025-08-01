//
//  UserDetailsViewModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import Foundation
import Combine

final class UserDetailsViewModel: ObservableObject {
    typealias Dependencies = HasUserDetailsRemoteDataSource
    
    enum RepositoriesState {
        case loading
        case content
    }
    
    private let model: UserResponseModel
    private let remoteDataSource: UserDetailsRemoteDataSource
    
    private(set) var repositories: [RepositoryResponseModel] = []
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
        self.remoteDataSource = dependencies.userDetailsRemoteDataSource
    }
}

extension UserDetailsViewModel {
    func getRepositories() {
        repositoriesState = .loading
        
        remoteDataSource.getRepositories(by: name)
            .receive(on: DispatchQueue.main)
            .sink { status in
                switch status {
                case .finished:
                    return
                case .failure(let error):
                    print("error - \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] repositories in
                guard let self else { return }
                self.repositories = repositories
                self.repositoriesState = .content
            }
            .store(in: &cancellables)
    }
    
    func onTap(_ repository: RepositoryResponseModel) {
        guard let url = URL(string: repository.htmlUrlPath) else { return }
        sheet = .safari(url: url)
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
