//
//  ProfileView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            contentBodyView
                .onAppear {
                    viewModel.getProfile()
                }
                .alert(item: $viewModel.alert) { alert in
                    switch alert {
                    case .error(let message):
                        Alert(title: Text(alert.title),
                              message: Text(alert.message),
                              dismissButton: .cancel(Text(alert.dismissButtonTitle)))
                    }
                }
                .confirmationDialog("Are you sure you want to log out?",
                                    isPresented: $viewModel.showLogoutConfirmationDialog,
                                    titleVisibility: .visible) {
                    Button("Log Out", role: .destructive) {
                        viewModel.logout()
                    }
                }
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: ViewHistoryType.self) { type in
                    switch type {
                    case .repositories:
                        ViewHistoryRepositoriesView(viewModel: ViewHistoryRepositoriesViewModel(dependencies: viewModel.dependencies))
                    case .users:
                        ViewHistoryUsersView(viewModel: ViewHistoryUsersViewModel(dependencies: viewModel.dependencies))
                    }
                }
        }
    }
}

fileprivate extension ProfileView {
    @ViewBuilder
    var contentBodyView: some View {
        VStack(spacing: 8) {
            switch viewModel.state {
            case .loading:
                userInfoLoadingView
                    .padding(.bottom, 8)
            case .content:
                userInfoView
                    .padding(.bottom, 8)
            }
            
            viewHistoryView
                .padding(.bottom, 40)
            
            logoutButtonView
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    var userInfoView: some View {
        VStack(spacing: 8) {
            avatarView
            
            nameView
        }
    }
    
    var userInfoLoadingView: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color(.systemGray2))
                .frame(width: 120, height: 120)
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray2))
                .frame(width: 120, height: 20)
        }
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
    
    var viewHistoryView: some View {
        VStack(spacing: 10) {
            Text("View History:")
                .font(.callout)
                .fontWeight(.medium)
                .fontDesign(.rounded)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 0) {
                Text("Repositories")
                    .font(.body)
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        navigationPath.append(ViewHistoryType.repositories)
                    }
                
                Divider()
                
                Text("Users")
                    .font(.body)
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        navigationPath.append(ViewHistoryType.users)
                    }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray5))
            )
        }
    }
    
    var logoutButtonView: some View {
        Button {
            viewModel.showLogoutConfirmationDialog = true
        } label: {
            Text("Log Out")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(.white)
                .frame(height: 44)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.red)
                )
        }
    }
}

#Preview {
    let mockDependencies = Dependencies()
    let mockViewModel = ProfileViewModel(dependencies: mockDependencies)
    
    ProfileView(viewModel: mockViewModel)
}
