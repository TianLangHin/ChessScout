//
//  ChessPieceView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 22/8/2025.
//

import SwiftUI

/// Represents a singular chess piece which will appear inside a chessboard.
struct ChessPieceView: View {
    // This is a Binding and not State, because the image must be updated when a piece gets promoted.
    @Binding var chessPiece: ChessPiece

    var body: some View {
        // The chess pieces are images taken from the publicly available chess.com assets.
        // They are named such that every image can be referenced by a string of two letters.
        // The first letter is either "w" or "b", meaning White or Black respectively.
        // The second letter is the piece type (from "p", "n", "b", "r", "q", "k"),
        // meaning pawn, knight, bishop, rook, queen, and king respectively.
        // This allows easy usage of existing `ChessKit` formatting functionality.
        let colour = chessPiece.data.color.rawValue
        let pieceType = chessPiece.data.kind == .pawn ? "p" : chessPiece.data.kind.notation.lowercased()
        Image("\(colour)\(pieceType)")
            .resizable()
            .scaledToFill()
    }
}
