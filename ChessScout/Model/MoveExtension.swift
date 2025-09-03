//
//  MoveExtension.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 24/8/2025.
//

import ChessKit

/// This adds on a function to convert a `Move` instance (from `ChessKit`) to UCI notation,
/// which allows it to be used in various APIs such as the Lichess API.
extension Move {
    func uci() -> String {
        let start = self.start.notation
        let end = self.end.notation
        let promote = self.promotedPiece?.kind.rawValue ?? ""
        return "\(start)\(end)\(promote)"
    }
}
