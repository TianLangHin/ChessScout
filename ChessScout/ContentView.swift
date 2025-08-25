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
        Text("ChessScout")
            .font(.title)
        OpeningExplorerView()
    }
}

#Preview {
    ContentView()
}
