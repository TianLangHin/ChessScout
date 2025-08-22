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

    @discardableResult
    func makeMove(move: Move) -> Bool {
        self.model.makeMove(move: move)
    }

    func setPosition(startpos: Position) {
        self.model.setPosition(startpos: startpos)
    }
}
