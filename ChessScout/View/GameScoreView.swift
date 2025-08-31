//
//  GameScoreView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

struct GameScoreView: View {

    @Binding var path: [GameRouterViewModel.Indicator]
    @State var score: Int
    @State var rounds: Int

    var body: some View {
        VStack {
            Text("You scored \(score) points out of \(rounds) rounds!")
                .font(.title2)
            Button {
                path.removeAll()
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back to main page")
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
