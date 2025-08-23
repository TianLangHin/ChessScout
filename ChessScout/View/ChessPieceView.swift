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
        let pieceType = switch chessPiece.piece.kind {
        case .pawn:
            "p"
        case .knight:
            "n"
        case .bishop:
            "b"
        case .rook:
            "r"
        case .queen:
            "q"
        case .king:
            "k"
        }
        let url = URL(string: "https://www.chess.com/chess-themes/pieces/neo/300/\(colour)\(pieceType).png")
        AsyncImage(url: url) { result in
            result.image?.resizable().scaledToFill()
        }
    }
}
