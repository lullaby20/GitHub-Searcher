//
//  ProfileView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 02.08.2025.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        contentBodyView
    }
}

fileprivate extension ProfileView {
    var contentBodyView: some View {
        Text("Profile View")
    }
}

#Preview {
    let mockDependencies = Dependencies()
    let mockViewModel = ProfileViewModel(dependencies: mockDependencies)
    
    ProfileView(viewModel: mockViewModel)
}
