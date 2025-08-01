//
//  RepositoryItemView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import SwiftUI

struct RepositoryItemView: View {
    let model: RepositoryResponseModel
    
    var body: some View {
        contentBodyView
    }
}

fileprivate extension RepositoryItemView {
    var contentBodyView: some View {
        VStack(spacing: 4) {
            nameView
                .frame(maxWidth: .infinity, alignment: .leading)
            
            detailsView
                .frame(maxWidth: .infinity, alignment: .leading)
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
        Text(model.name)
            .font(.system(size: 18, design: .rounded))
    }
    
    var updatedAtDateView: some View {
        Text("Updated at: " + model.updatedAt.toShortDateString())
            .font(.system(size: 12, design: .rounded))
            .foregroundStyle(.secondary)
    }
    
    var starsCountView: some View {
        (
            Text(Image(systemName: "star.fill"))
                .foregroundStyle(.yellow)
            +
            Text(" : \(model.starsCount)")
        )
        .font(.system(size: 12, design: .rounded))
        .foregroundStyle(.secondary)
    }
    
    var forksCountView: some View {
        (
            Text(Image(systemName: "tuningfork"))
                .foregroundStyle(.secondary)
            +
            Text(" : \(model.forksCount)")
        )
        .font(.system(size: 12, design: .rounded))
        .foregroundStyle(.secondary)
    }
    
    var ownerNameView: some View {
        Text("By \(model.owner.login)")
            .font(.system(size: 12, design: .rounded))
            .foregroundStyle(.secondary)
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
    
    RepositoryItemView(model: mockModel)
        .padding(.horizontal, 16)
}
