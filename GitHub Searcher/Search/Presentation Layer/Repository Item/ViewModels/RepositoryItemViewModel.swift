//
//  RepositoryItemViewModel.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 03.08.2025.
//

import Foundation
import Combine

final class RepositoryItemViewModel: ObservableObject {
    private let model: RepositoryResponseModel
    private let viewHistoryLocalDataSource: ViewHistoryLocalDataSource
    
    let onTapSubject: PassthroughSubject<URL, Never> = .init()
    
    @Published var isViewed: Bool
    
    var id: Int {
        model.id
    }
    
    var name: String {
        model.name
    }
    
    var updatedDate: String {
        model.updatedAt.toShortDateString()
    }
    
    var starsCount: Int {
        model.starsCount
    }
    
    var forksCount: Int {
        model.forksCount
    }
    
    var ownerName: String {
        model.owner.login
    }
    
    var htmlUrlPath: String {
        model.htmlUrlPath
    }
    
    init(model: RepositoryResponseModel,
         viewHistoryLocalDataSource: ViewHistoryLocalDataSource) {
        self.model = model
        self.viewHistoryLocalDataSource = viewHistoryLocalDataSource
        self.isViewed = viewHistoryLocalDataSource.containsRepository(by: model.id)
    }
}

extension RepositoryItemViewModel {
    func onTap() {
        guard let url = URL(string: htmlUrlPath) else { return }
        onTapSubject.send(url)
        viewHistoryLocalDataSource.append(model)
        isViewed = viewHistoryLocalDataSource.containsRepository(by: id)
    }
}

extension RepositoryItemViewModel: Identifiable {}
