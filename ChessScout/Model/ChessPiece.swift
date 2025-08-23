//
//  ChessPiece.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 22/8/2025.
//

import ChessKit
import Foundation

struct ChessPiece: Identifiable {
    let id = UUID()

    var piece: Piece

    var squareNumber: Int {
        get {
            self.piece.square.rawValue
        }
    }
}
