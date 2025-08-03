//
//  UserItemViewModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 03.08.2025.
//

import Foundation
import Combine

final class UserItemViewModel: ObservableObject {
    private let model: UserResponseModel
    private let viewHistoryRepository: ViewHistoryRepository
    private var cancellables: Set<AnyCancellable> = .init()
    
    let onTapSubject: PassthroughSubject<UserResponseModel, Never> = .init()
    
    @Published var isViewed: Bool
    
    var id: Int {
        model.id
    }
    
    var avatarUrl: URL? {
        URL(string: model.avatarUrlPath)
    }
    
    var login: String {
        model.login
    }
    
    init(model: UserResponseModel,
         viewHistoryRepository: ViewHistoryRepository) {
        self.model = model
        self.viewHistoryRepository = viewHistoryRepository
        self.isViewed = viewHistoryRepository.containsUser(by: model.id)
        
        viewHistoryRepository.didChangeSubject
            .sink { [weak self] in
                guard let self else { return }
                self.isViewed = viewHistoryRepository.containsUser(by: model.id)
            }
            .store(in: &cancellables)
    }
}

extension UserItemViewModel {
    func onTap() {
        onTapSubject.send(model)
        viewHistoryRepository.append(model)
        isViewed = viewHistoryRepository.containsUser(by: id)
    }
}

extension UserItemViewModel: Identifiable {}
