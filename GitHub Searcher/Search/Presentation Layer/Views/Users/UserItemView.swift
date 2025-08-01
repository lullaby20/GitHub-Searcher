//
//  UserItemView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import SwiftUI

struct UserItemView: View {
    let model: UserResponseModel
    
    var body: some View {
        contentBodyView
    }
}

fileprivate extension UserItemView {
    var contentBodyView: some View {
        HStack(spacing: 10) {
            avatarView
            
            nameView
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray5))
        )
    }
    
    @ViewBuilder
    var avatarView: some View {
        AsyncImage(url: URL(string: model.avatarUrlPath)) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            case .failure:
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(Color(.systemGray2))
            case .empty:
                Circle()
                    .fill(Color(.systemGray2))
                    .frame(width: 40, height: 40)
            @unknown default:
                EmptyView()
            }
        }
    }
    
    var nameView: some View {
        Text(model.login)
            .font(.system(size: 18, design: .rounded))
    }
}

#Preview {
    let mockModel = UserResponseModel(id: 0, login: "Mock User", avatarUrlPath: "")
    
    UserItemView(model: mockModel)
}
