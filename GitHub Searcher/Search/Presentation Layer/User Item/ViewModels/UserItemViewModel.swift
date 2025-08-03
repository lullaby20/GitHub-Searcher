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
    private let viewHistoryLocalDataSource: ViewHistoryLocalDataSource
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
         viewHistoryLocalDataSource: ViewHistoryLocalDataSource) {
        self.model = model
        self.viewHistoryLocalDataSource = viewHistoryLocalDataSource
        self.isViewed = viewHistoryLocalDataSource.containsUser(by: model.id)
        
        viewHistoryLocalDataSource.didChangeSubject
            .sink { [weak self] in
                guard let self else { return }
                self.isViewed = viewHistoryLocalDataSource.containsUser(by: model.id)
            }
            .store(in: &cancellables)
    }
}

extension UserItemViewModel {
    func onTap() {
        onTapSubject.send(model)
        viewHistoryLocalDataSource.append(model)
        isViewed = viewHistoryLocalDataSource.containsUser(by: id)
    }
}

extension UserItemViewModel: Identifiable {}
