//
//  ViewHistoryUsersView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 03.08.2025.
//

import SwiftUI

struct ViewHistoryUsersView: View {
    let viewModel: ViewHistoryUsersViewModel
    
    var body: some View {
        contentBodyView
            .padding(.horizontal, 16)
            .navigationTitle("Viewed Users")
    }
}

fileprivate extension ViewHistoryUsersView {
    @ViewBuilder
    var contentBodyView: some View {
        if viewModel.usersViewModel.isEmpty {
            emptyView
        } else {
            usersListView
        }
    }
    
    var usersListView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 5) {
                ForEach(viewModel.usersViewModel) { userViewModel in
                    UserItemView(viewModel: userViewModel)
                }
            }
            .padding(.bottom, 16)
        }
    }
    
    var emptyView: some View {
        ContentUnavailableView("No Viewed Users",
                               systemImage: "magnifyingglass",
                               description: Text("Users you view will appear here."))
    }
}

#Preview {
    let mockDependencies = Dependencies()
    let mockViewModel = ViewHistoryUsersViewModel(dependencies: mockDependencies)
    
    ViewHistoryUsersView(viewModel: mockViewModel)
}
