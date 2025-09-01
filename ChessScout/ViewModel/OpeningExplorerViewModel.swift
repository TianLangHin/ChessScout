//
//  OpeningExplorerViewModel.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 1/9/2025.
//

import ChessKit
import SwiftUI

@Observable
class OpeningExplorerViewModel {
    typealias GameState = (Move, Position)
    typealias WrappedGameState = IdWrapper<GameState>
    typealias WrappedStats = IdWrapper<LichessOpeningData.MoveStats>

    let openingFetcher = LichessOpeningFetcher()

    var useMastersDatabase = true
    var history: [WrappedGameState] = []
    var future: [WrappedGameState] = []

    func makeMove(move: Move, newState: Position, clearFuture: Bool = true) {
        let state = (move, newState)
        self.history.append(WrappedGameState(data: state))
        if move == self.future.last?.data.0 {
            let _ = self.future.popLast()
        } else if clearFuture {
            self.future.removeAll()
        }
    }

    func setState(gameState: WrappedGameState) -> Bool {
        let pastStop = self.history.first(where: { $0.id == gameState.id })
        let futureStop = self.future.first(where: { $0.id == gameState.id })
        if let snapshot = pastStop {
            while let shiftedElement = self.history.popLast() {
                if shiftedElement.id == snapshot.id {
                    self.history.append(shiftedElement)
                    break
                }
                self.future.append(shiftedElement)
            }
            return true
        } else if let snapshot = futureStop {
            while let shiftedElement = self.future.popLast() {
                self.history.append(shiftedElement)
                if shiftedElement.id == snapshot.id {
                    break
                }
            }
            return true
        } else {
            return false
        }
    }

    func fetch() async -> [WrappedStats] {
        let query = LichessOpeningQuery(
            openingPath: .moves(self.history.map({ $0.data.0 })),
            openingDatabase: self.useMastersDatabase ? .masters : .casual)
        let openingData = await openingFetcher.fetch(query)?.moves ?? []
        return openingData.map({ IdWrapper(data: $0) })
    }
}
