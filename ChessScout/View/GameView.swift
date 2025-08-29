//
//  GameView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

struct GameView: View {

    @EnvironmentObject var openingLines: OpeningLinesViewModel

    @Binding var path: [GameRouterViewModel.Indicator]
    @State var chessboard = ChessboardView()

    var body: some View {
        VStack {
            chessboard
            Button {
                let index = Int.random(in: 0..<openingLines.openingLines.count)
                chessboard.resetState()
                if let line = openingLines.openingLines[index].makePlayableLine() {
                    for move in line {
                        chessboard.makeTransition(move)
                    }
                }
            } label: {
                Text("Show random line")
            }
            Button {
                path.append(.score)
            } label: {
                Text("End Game")
            }
        }
    }
}
