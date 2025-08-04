//
//  UserItemLoadingView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import SwiftUI

struct UserItemLoadingView: View {
    var body: some View {
        contentBodyView
    }
}

fileprivate extension UserItemLoadingView {
    var contentBodyView: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(Color(.systemGray2))
                .frame(width: 40, height: 40)
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray2))
                .frame(width: 150, height: 20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray5))
        )
    }
}

#Preview {
    UserItemLoadingView()
}
