//
//  SearchView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        contentBodyView
    }
}

fileprivate extension SearchView {
    var contentBodyView: some View {
        Text("Search View")
    }
}

#Preview {
    let mockDependencies: Dependencies = Dependencies()
    
    SearchView(viewModel: SearchViewModel(dependencies: mockDependencies))
}
