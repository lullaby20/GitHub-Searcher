//
//  ProfileViewModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject {
    typealias Dependencies =
        HasProfileRemoteDataSource &
        HasViewHistoryLocalDataSource &
        HasAppConfigUseCase
    
    enum State {
        case loading
        case content
        case failure
    }
    
    let dependencies: Dependencies
    
    private let remoteDataSource: ProfileRemoteDataSource
    private let viewHistoryLocalDataSource: ViewHistoryLocalDataSource
    private let appConfigUseCase: AppConfigUseCase
    
    private var model: UserResponseModel?
    private var cancellables: Set<AnyCancellable> = .init()
    
    @Published var state: State = .loading
    @Published var showLogoutConfirmationDialog: Bool = false
    
    var avatarUrl: URL? {
        guard let urlPath = model?.avatarUrlPath else { return nil }
        return URL(string: urlPath)
    }
    
    var name: String {
        model?.login ?? ""
    }
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.remoteDataSource = dependencies.profileRemoteDataSource
        self.viewHistoryLocalDataSource = dependencies.viewHistoryLocalDataSource
        self.appConfigUseCase = dependencies.appConfigUseCase
    }
}

extension ProfileViewModel {
    func getProfile() {
        state = .loading
        
        remoteDataSource.getProfile()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                switch status {
                case .finished:
                    self.state = .content
                case .failure:
                    self.state = .failure
                }
            } receiveValue: { [weak self] userModel in
                guard let self else { return }
                self.model = userModel
            }
            .store(in: &cancellables)
    }
    
    func logout() {
        appConfigUseCase.changeAppState(to: .unauthorized)
        viewHistoryLocalDataSource.clearAll()
    }
}
