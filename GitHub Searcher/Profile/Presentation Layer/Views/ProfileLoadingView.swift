//
//  ProfileLoadingView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import SwiftUI

struct ProfileLoadingView: View {
    var body: some View {
        contentBodyView
    }
}

fileprivate extension ProfileLoadingView {
    var contentBodyView: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color(.systemGray2))
                .frame(width: 120, height: 120)
            
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(.systemGray2))
                .frame(width: 120, height: 20)
                .padding(.bottom, 8)
            
            viewHistoryView
                .padding(.bottom, 40)
            
            logoutButtonView
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    
    var viewHistoryView: some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.systemGray2))
                .frame(width: 120, height: 15)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(alignment: .leading, spacing: 0) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.systemGray2))
                    .frame(width: 200, height: 24)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)

                Divider()

                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.systemGray2))
                    .frame(width: 120, height: 24)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray5))
            )
        }
    }
    
    var logoutButtonView: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(.systemGray2))
            .frame(height: 44)
            .frame(maxWidth: .infinity)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(.systemGray5))
                    .frame(width: 150, height: 20)
            }
    }
}

#Preview {
    ProfileLoadingView()
}
