//
//  UserItemView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import SwiftUI

struct UserItemView: View {
    @ObservedObject var viewModel: UserItemViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        contentBodyView
            .onTapGesture {
                viewModel.onTap()
            }
    }
}

fileprivate extension UserItemView {
    var contentBodyView: some View {
        HStack(spacing: 10) {
            avatarView
            
            nameView
            
            Spacer()
            
            viewedView
                .padding(.trailing, 16)
                .opacity(viewModel.isViewed ? 1 : 0)
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
        AsyncImage(url: viewModel.avatarUrl) { phase in
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
        Text(viewModel.login)
            .font(.system(size: 18, design: .rounded))
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
    let mockModel = UserResponseModel(id: 0, login: "Mock User", avatarUrlPath: "")
    let mockViewHistoryRepository = ViewHistoryDefaultRepository(localDataSource: ViewHistoryLocalDefaultDataSource())
    let mockViewModel = UserItemViewModel(model: mockModel, viewHistoryRepository: mockViewHistoryRepository)
    
    UserItemView(viewModel: mockViewModel)
}
