//
//  ChessPieceView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 22/8/2025.
//

import SwiftUI

struct ChessPieceView: View {
    @Binding var chessPiece: ChessPiece

    var body: some View {
        let colour = chessPiece.piece.color.rawValue
        let pieceType = chessPiece.piece.kind == .pawn ? "p" : chessPiece.piece.kind.notation.lowercased()
        Image("\(colour)\(pieceType)").resizable().scaledToFill()
    }
}
