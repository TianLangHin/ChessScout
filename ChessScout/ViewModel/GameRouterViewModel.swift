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
        case .game:
            GameView(path: path)
                .navigationBarBackButtonHidden()
        case .score:
            GameScoreView(path: path)
                .navigationBarBackButtonHidden()
        }
    }
    enum GameState {
        case select
        case game
        case score
    }
}

