//
//  ChessboardViewModel.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 22/8/2025.
//

import ChessKit
import SwiftUI

/// This ViewModel wraps the logic of the `Chessboard` class to allow pieces to be tracked
/// for animation purposes where each piece conforms to the `Idenfitiable` protocol.
/// It uses the new `Observable` attribute to simplify its usage in a View.
@Observable
class ChessboardViewModel {
    var model = Chessboard()

    var position: Position {
        self.model.board.position
    }

    // This computed property is assignable so that its usage in `ForEach` is seamless.
    var pieceList: [ChessPiece] {
        get {
            self.model.pieceList
        }
        set {
            self.model.pieceList = newValue
        }
    }

    // This function wraps the `makeMove` functionality defined by the inner `Chessboard` instance.
    @discardableResult
    func makeMove(move: Move) -> Bool {
        self.model.makeMove(move: move)
    }

    // This function wraps the `setPosition` functionality defined by the inner `Chessboard` instance.
    func setPosition(position: Position) {
        self.model.setPosition(position: position)
    }
}
