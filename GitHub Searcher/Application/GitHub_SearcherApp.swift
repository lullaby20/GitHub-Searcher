//
//  GitHub_SearcherApp.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 29.07.2025.
//

import SwiftUI

@main
struct GitHub_SearcherApp: App {
    let dependencies: Dependencies = Dependencies()
    
    var body: some Scene {
        WindowGroup {
            RootView(dependencies: dependencies)
        }
    }
}
