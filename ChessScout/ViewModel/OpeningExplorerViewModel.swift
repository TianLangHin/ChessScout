//
//  OpeningExplorerViewModel.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 1/9/2025.
//

import ChessKit
import SwiftUI

/// This ViewModel handles the back and forth navigation of an opening sequence
/// in the `OpeningExplorerView`. It operates on the following rules:
/// every position is navigated to by a sequence of moves that starts from the initial position.
/// A user can move back and forth within this sequence to explore each snapshot.
/// If a user goes back within the sequence and chooses a different path,
/// it overwrites whichever line was previously explored to clear the way for the new line.
@Observable
class OpeningExplorerViewModel {
    // Type aliases defined for convenience within this file.
    // Some of these are `IdWrapper` types so that published items can be directly put into
    // a ForEach seamlessly.
    typealias GameState = (Move, Position)
    typealias WrappedGameState = IdWrapper<GameState>
    typealias WrappedStats = IdWrapper<LichessOpeningData.MoveStats>

    // Internally, this OpeningExplorer also provides an interface to the Lichess opening database fetcher.
    let openingFetcher = LichessOpeningFetcher()

    // This ViewModel keeps track of the "history" (moves before and including the current one)",
    // "future" (moves after the current one) and whether the Lichess masters database is being fetched from.
    var useMastersDatabase: Bool
    var history: [WrappedGameState]
    var future: [WrappedGameState]

    // The initialiser sets everything to empty, and by default uses the masters database.
    init() {
        self.useMastersDatabase = true
        self.history = []
        self.future = []
    }

    // This reset function is used for clearing any previous persistent state when reloading the UI.
    func reset() {
        self.useMastersDatabase = true
        self.history = []
        self.future = []
    }

    /// Function for registering the change where the user makes a move in a position.
    func makeMove(move: Move, newState: Position, clearFuture: Bool = true) {
        let state = (move, newState)
        // Firstly, append the "current" state to the history.
        self.history.append(WrappedGameState(data: state))
        if move == self.future.last?.data.0 {
            // If the move made now matches the "future" move sequence,
            // do not clear it.
            let _ = self.future.popLast()
        } else if clearFuture {
            // If the move made now does not match the "future" move sequence,
            // and this move should potentially clear the future,
            // then clear it to make way for a new sequence.
            self.future.removeAll()
        }
    }

    /// Function for registering the change where the user decides to reset to an
    /// arbitrary position in the move sequence (which may either be in the future or the past).
    /// Returns whether the jump was successful or not.
    func setState(gameState: WrappedGameState) -> Bool {
        // First, check whether the game state being moved to is present anywhere in the sequence.
        let pastStop = self.history.first(where: { $0.id == gameState.id })
        let futureStop = self.future.first(where: { $0.id == gameState.id })
        if let snapshot = pastStop {
            // If the position being jumped to is in the past,
            // then keep removing elements from the end of the history
            // until the position is reached, moving them to the future each time.
            while let shiftedElement = self.history.popLast() {
                if shiftedElement.id == snapshot.id {
                    self.history.append(shiftedElement)
                    break
                }
                self.future.append(shiftedElement)
            }
            return true
        } else if let snapshot = futureStop {
            // If the position being jumped to is in the future,
            // then keep removing elements from the future and adding it
            // to the history until the last element of `history` is the current state.
            while let shiftedElement = self.future.popLast() {
                self.history.append(shiftedElement)
                if shiftedElement.id == snapshot.id {
                    break
                }
            }
            return true
        } else {
            // If the state is not present in the timeline, then do nothing.
            // The operation was unsuccessful, hence return `false`.
            return false
        }
    }

    /// Used as a way to wrap the functionality of the API call without the View
    /// needing to directly instantiate the LichessOpeningFetcher.
    func fetch() async -> [WrappedStats] {
        // Uses the current stored properties to form the query based on the current board position.
        let query = LichessOpeningQuery(
            openingPath: .moves(self.history.map({ $0.data.0 })),
            openingDatabase: self.useMastersDatabase ? .masters : .casual)
        let openingData = await openingFetcher.fetch(query)?.moves ?? []
        return openingData.map({ IdWrapper(data: $0) })
    }
}
