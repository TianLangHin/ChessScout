//
//  GameSelectView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

struct GameSelectView: View {

    let openingNamesFetcher = OpeningNamesFetcher()

    @Binding var path: [GameRouterViewModel.Indicator]
    @State var openings: [OpeningNamesFetcher.NamedOpeningLine] = []
    @State var index: Int = 0
    @State var chessBoard = ChessboardView()

    var body: some View {
        VStack {
            Spacer()
            chessBoard
            Spacer()
            Button {
                chessBoard.resetState()
                if let moves = openings[index].makePlayableLine() {
                    for move in moves {
                        chessBoard.makeTransition(move)
                    }
                }
                index = (index + 1) % openings.count
            } label: {
                Text("Index: \(index)")
                if index < openings.count {
                    Text("\(openings[index].eco)")
                    Text("\(openings[index].line)")
                    Text("\(openings[index].moves)")
                }
            }
            Spacer()
            Button {
                path.append(.game)
            } label: {
                Text("Move to Game")
            }
            Spacer()
        }
        .padding()
        .onAppear {
            Task {
                openings = await openingNamesFetcher.fetch(.c) ?? []
            }
        }
    }
}
