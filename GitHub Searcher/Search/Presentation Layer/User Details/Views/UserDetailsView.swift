//
//  UserDetailsView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import SwiftUI

struct UserDetailsView: View {
    @ObservedObject var viewModel: UserDetailsViewModel
    
    var body: some View {
        contentBodyView
            .onAppear {
                viewModel.getRepositories()
            }
            .sheet(item: $viewModel.sheet, onDismiss: { [unowned viewModel] in
                viewModel.sheet = nil
            }) { sheet in
                switch sheet {
                case .safari(let url):
                    SafariView(url: url)
                }
            }
    }
}

fileprivate extension UserDetailsView {
    var contentBodyView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 8) {
                avatarView
                
                nameView
                
                repositoriesView
            }
            .padding(.top, 10)
        }
        .padding(.horizontal, 16)
        .navigationTitle("User details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var avatarView: some View {
        AsyncImage(url: viewModel.avatarUrl) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            case .failure:
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundStyle(Color(.systemGray2))
            case .empty:
                Circle()
                    .fill(Color(.systemGray2))
                    .frame(width: 120, height: 120)
            @unknown default:
                EmptyView()
            }
        }
    }
    
    var nameView: some View {
        Text(viewModel.name)
            .font(.title3)
            .fontDesign(.rounded)
    }
    
    var repositoriesView: some View {
        VStack(spacing: 8) {
            Text("Repositories:")
                .font(.system(size: 14, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            repositoriesStateView
        }
    }
    
    @ViewBuilder
    var repositoriesStateView: some View {
        switch viewModel.repositoriesState {
        case .loading:
            ForEach(0..<6) { _ in
                RepositoryItemLoadingView()
            }
        case .content:
            ForEach(viewModel.repositories) { repository in
                Button {
                    viewModel.onTap(repository)
                } label: {
                    RepositoryItemView(model: repository)
                }
                .buttonStyle(.plain)
            }
        case .empty:
            ContentUnavailableView("Nothing here yet!",
                                   systemImage: "magnifyingglass",
                                   description: Text("Maybe this user is working on something awesome in private."))
        }
    }
}

#Preview {
    let mockDependencies = Dependencies()
    let mockUser = UserResponseModel(id: 0, login: "Mock User", avatarUrlPath: "")
    let mockViewModel = UserDetailsViewModel(model: mockUser, dependencies: mockDependencies)
    
    UserDetailsView(viewModel: mockViewModel)
}
