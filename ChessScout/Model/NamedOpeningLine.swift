//
//  NamedOpeningLine.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 3/9/2025.
//

import ChessKit

/// This struct conforms to `Codable` for easy persistent storage as JSON,
/// `Equatable` so that duplicates can be detected in an array,
/// and `Hashable` so it can be displayed directly in a `List`.
/// It is also the struct that is outputted directly from the TSV files in the separate Lichess opening encyclopedia.
struct NamedOpeningLine: Codable, Equatable, Hashable {
    /// These three directly correspond to fields in the external TSV files.
    let eco: String
    let line: String
    let moves: [String]

    /// Converts an instance of `NamedOpeningLine` to a list of `Move` instances for compatibility with `ChessKit`.
    /// Since the moves are stored in algebraic notation,
    /// the position from which the move sequence is played needs to be known.
    /// By default, this is the regular starting position.
    /// It is possible for some moves to be incorrectly recorded, hence this returns an optional.
    func makePlayableLine(position: Position = .standard) -> [Move]? {
        var moveList: [Move] = []
        // This is used to track the position changes as the moves in the sequence are made.
        var board = Board(position: position)
        for moveString in self.moves {
            // If the move failed to be converted, or it is illegal, then the conversion has failed.
            // Hence, `nil` is immediately returned.
            guard let validMove = Move(san: moveString, position: board.position) else {
                return nil
            }
            guard let resultantMove = board.move(pieceAt: validMove.start, to: validMove.end) else {
                return nil
            }
            // If the move was successful and the move in the sequence is a promotion,
            // complete the logic using `completePromotion`.
            if let promotedPiece = validMove.promotedPiece {
                board.completePromotion(of: resultantMove, to: promotedPiece.kind)
            }
            moveList.append(validMove)
        }
        return moveList
    }
}
