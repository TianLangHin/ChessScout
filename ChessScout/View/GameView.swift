//
//  GameView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

struct GameView: View {

    @Binding var path: [GameRouterViewModel.Indicator]

    var body: some View {
        VStack {
            Button {
                path.append(.score)
            } label: {
                Text("End Game")
            }
        }
    }
}
