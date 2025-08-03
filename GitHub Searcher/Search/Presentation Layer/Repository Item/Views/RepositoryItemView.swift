//
//  RepositoryItemView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import SwiftUI

struct RepositoryItemView: View {
    @ObservedObject var viewModel: RepositoryItemViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        contentBodyView
            .onTapGesture {
                viewModel.onTap()
            }
    }
}

fileprivate extension RepositoryItemView {
    var contentBodyView: some View {
        HStack(spacing: 8) {
            VStack(spacing: 4) {
                nameView
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                detailsView
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            viewedView
                .padding(.trailing, 16)
                .opacity(viewModel.isViewed ? 1 : 0)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray5))
        )
    }
    
    var detailsView: some View {
        VStack(alignment: .leading, spacing: 2) {
            updatedAtDateView
            
            starsCountView
            
            forksCountView
            
            ownerNameView
        }
    }
    
    var nameView: some View {
        Text(viewModel.name)
            .font(.system(size: 18, design: .rounded))
    }
    
    var updatedAtDateView: some View {
        Text("Updated at: " + viewModel.updatedDate)
            .font(.system(size: 12, design: .rounded))
            .foregroundStyle(.secondary)
    }
    
    var starsCountView: some View {
        (
            Text(Image(systemName: "star.fill"))
                .foregroundStyle(.yellow)
            +
            Text(" : \(viewModel.starsCount)")
        )
        .font(.system(size: 12, design: .rounded))
        .foregroundStyle(.secondary)
    }
    
    var forksCountView: some View {
        (
            Text(Image(systemName: "tuningfork"))
                .foregroundStyle(.secondary)
            +
            Text(" : \(viewModel.forksCount)")
        )
        .font(.system(size: 12, design: .rounded))
        .foregroundStyle(.secondary)
    }
    
    var ownerNameView: some View {
        Text("By \(viewModel.ownerName)")
            .font(.system(size: 12, design: .rounded))
            .foregroundStyle(.secondary)
    }
    
    var viewedView: some View {
        VStack(spacing: 6) {
            Image(systemName: "checkmark.square.fill")
                .resizable()
                .foregroundStyle(.green)
                .frame(width: 20, height: 20)
            
            Text("Viewed")
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(colorScheme == .dark ? .white : .black)
        }
    }
}

#Preview {
    let mockModel = RepositoryResponseModel(id: 0,
                                            name: "Mock Repo",
                                            description: "This is Mock Repo",
                                            owner: UserResponseModel(id: 0, login: "Mock User", avatarUrlPath: ""),
                                            updatedAt: Date.now,
                                            forksCount: 2,
                                            starsCount: 3,
                                            htmlUrlPath: "")
    let mockViewHistoryLocalDataSource = ViewHistoryLocalDefaultDataSource()
    let mockViewModel = RepositoryItemViewModel(model: mockModel, viewHistoryLocalDataSource: mockViewHistoryLocalDataSource)
    
    RepositoryItemView(viewModel: mockViewModel)
        .padding(.horizontal, 16)
}
