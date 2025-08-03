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
    private let viewHistoryRepository: ViewHistoryRepository
    private var cancellables: Set<AnyCancellable> = .init()
    
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
         viewHistoryRepository: ViewHistoryRepository) {
        self.model = model
        self.viewHistoryRepository = viewHistoryRepository
        self.isViewed = viewHistoryRepository.containsRepository(by: model.id)
        
        viewHistoryRepository.didChangeSubject
            .sink { [weak self] in
                guard let self else { return }
                self.isViewed = viewHistoryRepository.containsRepository(by: model.id)
            }
            .store(in: &cancellables)
    }
}

extension RepositoryItemViewModel {
    func onTap() {
        guard let url = URL(string: htmlUrlPath) else { return }
        onTapSubject.send(url)
        viewHistoryRepository.append(model)
        isViewed = viewHistoryRepository.containsRepository(by: id)
    }
}

extension RepositoryItemViewModel: Identifiable {}
