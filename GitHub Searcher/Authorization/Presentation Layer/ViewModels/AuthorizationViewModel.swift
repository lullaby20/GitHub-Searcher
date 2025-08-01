//
//  AuthorizationViewModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 30.07.2025.
//

import Foundation
import Combine

final class AuthorizationViewModel {
    typealias Dependencies =
        HasAuthorizationUseCase &
        HasAppConfigUseCase
    
    private let useCase: AuthorizationUseCase
    private let appConfigUseCase: AppConfigUseCase
    private var authorizationCoordinator: AuthorizationCoordinator?
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(dependencies: Dependencies) {
        self.useCase = dependencies.authorizationUseCase
        self.appConfigUseCase = dependencies.appConfigUseCase
    }
    
    func startAuthorizationCoordinator() {
        let coordinator = AuthorizationCoordinator(useCase: useCase,
                                                   completion: { [unowned self] code in
            guard let code else { return }
            getToken(from: code)
        })
        
        authorizationCoordinator = coordinator
        coordinator.startAuthorization()
    }
}

fileprivate extension AuthorizationViewModel {
    func getToken(from code: String) {
        useCase.getToken(from: code)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print("error - \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] responseModel in
                guard let self else { return }
                self.useCase.saveAccessToken(responseModel.accessToken)
                self.authorizationCoordinator = nil
                self.setAuthorizedAppState()
            })
            .store(in: &cancellables)
    }
    
    func setAuthorizedAppState() {
        appConfigUseCase.changeAppState(to: .authorized)
    }
}
