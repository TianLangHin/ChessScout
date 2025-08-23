//
//  MoveExtension.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 24/8/2025.
//

import ChessKit

extension Move {
    func uci() -> String {
        let start = self.start.notation
        let end = self.end.notation
        let promote = self.promotedPiece?.kind.rawValue ?? ""
        return "\(start)\(end)\(promote)"
    }
}
