//
//  PieceAssetFetcher.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 22/8/2025.
//

import ChessKit
import Foundation

struct PieceAssetFetcher: APIFetchable {
    typealias Parameters = Piece
    typealias FetchedData = URL

    func fetch(_ piece: Parameters) -> FetchedData? {
        let colour = piece.color.rawValue
        let pieceType = switch piece.kind {
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
        return URL(string: "https://www.chess.com/chess-themes/pieces/neo/300/\(colour)\(pieceType).png")
    }
}
