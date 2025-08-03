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
