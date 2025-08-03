//
//  FailureView.swift
//  GitHub Searcher
//
//  Created by Daniyar Merekeyev on 03.08.2025.
//

import SwiftUI

struct FailureView: View {
    var body: some View {
        ContentUnavailableView("Oops...",
                               systemImage: "exclamationmark.circle",
                               description: Text("Something get wrong."))
    }
}

#Preview {
    FailureView()
}
