//
//  FailureView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 03.08.2025.
//

import SwiftUI

struct FailureView: View {
    let onTryAgain: () -> Void
    
    var body: some View {
        ContentUnavailableView {
            Image(systemName: "exclamationmark.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
            
            Text("Oops...")
                .font(.title2)
                .fontWeight(.bold)
                .fontDesign(.rounded)
            
            Text("Something get wrong.")
                .font(.callout)
                .foregroundColor(.secondary)
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
        } actions: {
            Button {
                onTryAgain()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.clockwise")
                    
                    Text("Try again")
                }
                .foregroundStyle(.white)
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .frame(height: 40)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.blue)
                )
            }
            .padding(.top, 24)
        }
    }
}

#Preview {
    FailureView(onTryAgain: {})
}
