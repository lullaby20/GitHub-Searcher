//
//  CircularLoadingView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 31.07.2025.
//

import SwiftUI

struct CircularLoadingView: View {
    var body: some View {
        Color.black
            .ignoresSafeArea(.all)
            .opacity(0.35)
            .overlay {
                ProgressView()
                    .scaleEffect(1.74)
                    .progressViewStyle(.circular)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white)
                            .frame(width: 120, height: 120)
                    )
            }
    }
}
