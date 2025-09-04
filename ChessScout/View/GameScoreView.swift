//
//  GameScoreView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

/// This View shows the final score of a game that has just been completed,
/// together with a prompt to bring the user back to the main page.
struct GameScoreView: View {
    // Since this view requires programmatically clearing the navigation stack,
    // it needs a binding to the array that governs the stack of Views.
    @Binding var path: [GameRouterViewModel.Indicator]

    // It also needs to display the score of the game and how many rounds it lasted.
    @State var score: Int
    @State var rounds: Int

    var body: some View {
        VStack {
            // Grammar inflection is used here for alignment with cases of 1 point or 1 round.
            Text("You scored ^[\(score) point](inflect: true) out of ^[\(rounds) round](inflect: true)!")
                .font(.title2)
            Button {
                // By clearing the `path` that governs the navigation stack,
                // the user is sent back to the home page.
                path.removeAll()
            } label: {
                HStack {
                    // The left chevron indicator provides a "backward moving" visual indicator.
                    Image(systemName: "chevron.left")
                    Text("Back to main page")
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
