//
//  NamedOpeningLine.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 3/9/2025.
//

import ChessKit

struct NamedOpeningLine: Codable, Equatable, Hashable {
    let eco: String
    let line: String
    let moves: [String]

    func makePlayableLine(position: Position = .standard) -> [Move]? {
        var moveList: [Move] = []
        var board = Board(position: position)
        for moveString in self.moves {
            guard let validMove = Move(san: moveString, position: board.position) else {
                return nil
            }
            guard let resultantMove = board.move(pieceAt: validMove.start, to: validMove.end) else {
                return nil
            }
            if let promotedPiece = validMove.promotedPiece {
                board.completePromotion(of: resultantMove, to: promotedPiece.kind)
            }
            moveList.append(validMove)
        }
        return moveList
    }
}
