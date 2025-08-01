//
//  RepositoryItemLoadingView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 01.08.2025.
//

import SwiftUI

struct RepositoryItemLoadingView: View {
    var body: some View {
        contentBodyView
    }
}

fileprivate extension RepositoryItemLoadingView {
    var contentBodyView: some View {
        VStack(alignment: .leading, spacing: 4) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray2))
                .frame(width: 200, height: 20)
                .padding(.bottom, 4)
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray2))
                .frame(width: 140, height: 15)
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray2))
                .frame(width: 60, height: 15)
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray2))
                .frame(width: 60, height: 15)
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray2))
                .frame(width: 100, height: 15)
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
    RepositoryItemLoadingView()
}
