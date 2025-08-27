//
//  ContentView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 16/8/2025.
//

import ChessKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text("ChessScout")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Image("wr")
                VStack(alignment: .leading) {
                    NavigationLink("Opening Explorer") {
                        OpeningExplorerView()
                            .navigationTitle("Opening Explorer")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
