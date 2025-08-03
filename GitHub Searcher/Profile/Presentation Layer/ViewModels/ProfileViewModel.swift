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
        HasProfileRepository &
        HasViewHistoryRepository &
        HasAppConfigUseCase
    
    enum State {
        case loading
        case content
    }
    
    let dependencies: Dependencies
    
    private let repository: ProfileRepository
    private let viewHistoryRepository: ViewHistoryRepository
    private let appConfigUseCase: AppConfigUseCase
    
    private var model: UserResponseModel?
    private var cancellables: Set<AnyCancellable> = .init()
    
    @Published var state: State = .loading
    @Published var showLogoutConfirmationDialog: Bool = false
    @Published var alert: Alert?
    
    var avatarUrl: URL? {
        guard let urlPath = model?.avatarUrlPath else { return nil }
        return URL(string: urlPath)
    }
    
    var name: String {
        model?.login ?? ""
    }
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.repository = dependencies.profileRepository
        self.viewHistoryRepository = dependencies.viewHistoryRepository
        self.appConfigUseCase = dependencies.appConfigUseCase
    }
}

extension ProfileViewModel {
    func getProfile() {
        state = .loading
        
        repository.getProfile()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                guard let self else { return }
                switch status {
                case .finished:
                    self.state = .content
                case .failure(let error):
                    self.alert = .error(message: error.localizedDescription)
                }
            } receiveValue: { [weak self] userModel in
                guard let self else { return }
                self.model = userModel
            }
            .store(in: &cancellables)
    }
    
    func logout() {
        appConfigUseCase.changeAppState(to: .unauthorized)
        viewHistoryRepository.clearAll()
    }
}

extension ProfileViewModel {
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
