//
//  ChessPiece.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 22/8/2025.
//

import ChessKit

/// `ChessPiece` represents a visual chess piece element.
/// It is a special case of the generic `IdWrapper` structure, which wraps any data and makes it identifiable.
/// This makes it possible to animate changes of these pieces.
typealias ChessPiece = IdWrapper<Piece>

extension ChessPiece {
    /// Its location can be represented by an integer from `0` to `63` inclusive,
    /// which is also directly derived from the `Piece` instance that it wraps.
    var squareNumber: Int {
        self.data.square.rawValue
    }
}
