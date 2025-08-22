//
//  Chessboard.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 22/8/2025.
//

import ChessKit
import SwiftUI

@Observable
class Chessboard {

    var board: Board
    var pieceList: [ChessPiece]

    init(startpos: Position = .standard) {
        self.board = Board(position: startpos)
        self.pieceList = startpos.pieces.map({ ChessPiece(piece: $0) })
    }

    @discardableResult
    func makeMove(move: Move) -> Bool {
        guard let resultantMove = self.board.move(pieceAt: move.start, to: move.end) else {
            return false
        }

        guard let startIndex = self.pieceList.firstIndex(where: { $0.piece.square == resultantMove.start }) else {
            return false
        }

        if let promotePiece = move.promotedPiece {
            self.board.completePromotion(of: resultantMove, to: promotePiece.kind)
            self.pieceList[startIndex].piece.kind = promotePiece.kind
        }

        switch resultantMove.result {
        case .move:
            self.pieceList[startIndex].piece.square = resultantMove.end
        case .capture(let piece):
            self.pieceList[startIndex].piece.square = resultantMove.end
            guard let captureIndex = self.pieceList.firstIndex(where: { $0.piece == piece }) else {
                return false
            }
            self.pieceList.remove(at: captureIndex)
        case .castle(let castling):
            let maybeKingIndex = self.pieceList.firstIndex(where: { $0.piece.square == castling.kingStart })
            let maybeRookIndex = self.pieceList.firstIndex(where: { $0.piece.square == castling.rookStart })
            guard let kingIndex = maybeKingIndex, let rookIndex = maybeRookIndex else {
                return false
            }
            self.pieceList[kingIndex].piece.square = castling.kingEnd
            self.pieceList[rookIndex].piece.square = castling.rookEnd
        }

        return true
    }

    func setPosition(startpos: Position) {
        self.board = Board(position: startpos)
        self.pieceList = startpos.pieces.map({ ChessPiece(piece: $0) })
    }
}
