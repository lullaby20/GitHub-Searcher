//
//  AuthorizationView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 30.07.2025.
//

import SwiftUI

struct AuthorizationView: View {
    @Environment(\.colorScheme) var colorScheme
    let viewModel: AuthorizationViewModel
    
    var body: some View {
        contentBodyView
    }
}

fileprivate extension AuthorizationView {
    private var contentBodyView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            githubLogoView
                .padding(.bottom, 10)
            
            titleView
                .padding(.bottom, 4)
            
            descriptionView
            
            Spacer()
            
            signInButton
                .padding(.bottom, 16)
        }
        .padding(.horizontal, 16)
    }
    
    private var githubLogoView: some View {
        Image(.github)
            .resizable()
            .frame(width: 100, height: 100)
    }
    
    private var titleView: some View {
        Text("Hi there!")
            .font(.title2)
            .fontDesign(.rounded)
    }
    
    private var descriptionView: some View {
        Text("To unlock GitHub Searcher features, please sign in with your GitHub account.")
            .font(.system(size: 15, design: .rounded))
            .multilineTextAlignment(.center)
    }
    
    private var signInButton: some View {
        Button {
            viewModel.startAuthorizationCoordinator()
        } label: {
            Text("Sign In")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundStyle(colorScheme == .light ? Color.white : Color.black)
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(colorScheme == .light ? Color.black : Color.white)
                )
        }
    }
}

#Preview {
    let mockDependencies = Dependencies()
    
    AuthorizationView(viewModel: AuthorizationViewModel(dependencies: mockDependencies))
}
