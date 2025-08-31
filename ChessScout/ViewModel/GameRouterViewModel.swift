//
//  GameRouterViewModel.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

@Observable
class GameRouterViewModel: Routable {
    typealias Indicator = GameRouterViewModel.GameState

    var gameStack: [Indicator] = []

    @ViewBuilder
    func getView(_ indicator: Indicator, path: Binding<[Indicator]>) -> some View {
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

    enum GameState: Hashable {
        case select
        case game(Int)
        case score(Int, Int)
    }
}

