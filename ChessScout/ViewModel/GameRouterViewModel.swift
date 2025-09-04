//
//  GameRouterViewModel.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

/// This ViewModel enables programmatic navigation between Views
/// for use with the main opening revision game functionality of the app.
/// It conforms to the `Routable` protocol,
/// since the protocol defines behaviour for governing programmatic navigation.
@Observable
class GameRouterViewModel: Routable {
    /// Satisfies the `Routable` protocol with an inner class, which in this case is an enumeration.
    typealias Indicator = GameRouterViewModel.GameState

    // This is specific to this ViewModel, and acts as the array that governs the
    // behaviour of the View stack within the game.
    var gameStack: [Indicator] = []

    /// Implemented to conform to the `Routable` protocol.
    @ViewBuilder
    func getView(_ indicator: Indicator, path: Binding<[Indicator]>) -> some View {
        // Since the View that will be loaded depends on the value of `indicator`,
        // and these Views are different concrete realisations of the generic View type,
        // the returned view structure is made flexible using the `@ViewBuilder` attribute.
        switch indicator {
        case .select:
            GameSelectView(path: path)
        case .game(let rounds):
            GameView(path: path, rounds: rounds)
                .navigationBarBackButtonHidden()
        case .score(let score, let rounds):
            GameScoreView(path: path, score: score, rounds: rounds)
                .navigationBarBackButtonHidden()
        }
    }

    /// The use of an enumeration to be the indicator of which view to show
    /// makes it clear in the program logic that the `GameRouterViewModel`
    /// will generate one of several distinct and defined View types.
    /// It also shows logically which Views need additional information loaded into them.
    enum GameState: Hashable {
        // GameSelectView requires no information.
        case select
        // GameView requires an integer (number of rounds).
        case game(Int)
        // GameScoreView requires two integers (score and number of rounds).
        case score(Int, Int)
    }
}

