//
//  OpeningExplorerView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 24/8/2025.
//

import ChessKit
import SwiftUI

struct OpeningExplorerView: View {
    
    let openingFetcher = LichessOpeningFetcher()
    
    @State var database: LichessOpeningQuery.OpeningDatabase = .masters
    @State var path: [(Move, Position)] = []
    @State var boardView = ChessboardView()
    @State var openings: [WrappedOpeningMoveStats] = []
    
    var body: some View {
        VStack {
            boardView
            List {
                ForEach(openings) { opening in
                    let moveStats = opening.moveStats
                    Button {
                        let move = Move(san: moveStats.san, position: boardView.getState())!
                        if boardView.makeTransition(move) {
                            path.append((move, boardView.getState()))
                            openings = []
                            updateMoveList()
                        }
                    } label: {
                        HStack {
                            Text("\(moveStats.san)")
                                .padding()
                            Spacer()
                            VStack {
                                Text("\(moveStats.averageRating)")
                                Text("\(moveStats.white)/\(moveStats.draws)/\(moveStats.black)")
                            }
                        }
                    }
                }
            }
            HStack {
                Spacer()
                Button {
                    if path.popLast() != nil {
                        openings = []
                        updateMoveList()
                        boardView.setState(path.last?.1 ?? .standard)
                    }
                } label: {
                    Text("Undo Move")
                }
            }
            .padding()
        }
        .onAppear(perform: {
            updateMoveList()
        })
    }

    private func updateMoveList() {
        let params = LichessOpeningQuery(
            openingPath: .moves(path.map({ $0.0 })),
            openingDatabase: database)
        Task {
            let rawOpenings = await openingFetcher.fetch(params)?.moves ?? []
            openings = rawOpenings.map({ WrappedOpeningMoveStats(moveStats: $0) })
        }
    }
}

struct WrappedOpeningMoveStats: Identifiable {
    let id = UUID()

    var moveStats: LichessOpeningData.MoveStats
}

#Preview {
    OpeningExplorerView()
}
