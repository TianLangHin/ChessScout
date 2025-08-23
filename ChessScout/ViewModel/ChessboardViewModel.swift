//
//  ChessboardViewModel.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 22/8/2025.
//

import ChessKit
import SwiftUI

@Observable
class ChessboardViewModel {
    var model = Chessboard()

    var position: Position {
        self.model.board.position
    }

    var pieceList: [ChessPiece] {
        get {
            self.model.pieceList
        }
        set {
            self.model.pieceList = newValue
        }
    }

    @discardableResult
    func makeMove(move: Move) -> Bool {
        self.model.makeMove(move: move)
    }

    func setPosition(position: Position) {
        self.model.setPosition(position: position)
    }
}
