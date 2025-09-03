//
//  Chessboard.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 22/8/2025.
//

import ChessKit
import SwiftUI

/// The `Chessboard` model represents a chess position,
/// which can be manipulated either by making a move or by directly setting its position.
/// It also separately keeps track of the list of pieces in the position to facilitate transition animations.
///
/// The `Chessboard` class is given the `@Observable` attribute
/// so that Views and ViewModels can track its changes in a simplified manner.
@Observable
class Chessboard {
    /// The model for a chess game implemented by `ChessKit`.
    /// This is used to manage the transition of legal moves,
    /// and acts as the core concept that this class wraps around.
    var board: Board
    /// This separate list of `ChessPiece` instances is maintained,
    /// so that the transitions of piece arrangements from one move to another
    /// is shown via `Identifiable` structs, allowing animations to be displayed.
    var pieceList: [ChessPiece]

    /// The `Chessboard` class can be initialised with any `Position` (from `ChessKit`),
    /// but for almost all cases will be initialised with the standard starting position.
    init(startpos: Position = .standard) {
        self.board = Board(position: startpos)
        /// The `pieceList` is initialised to match the list of pieces in the given `Position`.
        self.pieceList = startpos.pieces.map({ ChessPiece(data: $0) })
    }

    /// When a move is made in the represented chess position, it may turn out that the move was illegal.
    /// It returns `true` if the move was legal and successful, or `false` otherwise.
    @discardableResult
    func makeMove(move: Move) -> Bool {
        // First make the move in the inner `board` object.
        // If it fails, then this function cannot proceed successfully.
        guard let resultantMove = self.board.move(pieceAt: move.start, to: move.end) else {
            return false
        }
        // If the move is a promotion move, an extra step is required to update the `Board` object.
        if let promotePiece = move.promotedPiece {
            self.board.completePromotion(of: resultantMove, to: promotePiece.kind)
        }

        // Now that the internal `board` object has been updated,
        // we now update `pieceList` to reflect the change in an animation.

        // First, find the array index of the piece that matches the move's start square.
        guard let startIndex = self.pieceList.firstIndex(where: { $0.data.square == resultantMove.start }) else {
            // If this index cannot be found, then the animation does not exist.
            return false
        }

        // Once the corresponding `ChessPiece` instance is found, modify its piece type if it is promoted.
        if let promotePiece = move.promotedPiece {
            self.pieceList[startIndex].data.kind = promotePiece.kind
        }

        // Now, we also handle the generic case and the two other special move cases:
        // capturing (where a piece must be removed from `pieceList`) and
        // castle (where a king and rook must be moved).
        switch resultantMove.result {
        // The generic case.
        case .move:
            // The `square` attribute of the identified piece must be changed to the move's destination.
            self.pieceList[startIndex].data.square = resultantMove.end
        // The capturing case. The `Piece` being captured is contained in the enum.
        case .capture(let piece):
            // To start, the `square` attribute of the identified piece must be changed to the move's destination.
            self.pieceList[startIndex].data.square = resultantMove.end
            // Next, find the piece at the square which is being captured.
            guard let captureIndex = self.pieceList.firstIndex(where: { $0.data == piece }) else {
                // If it is not found, then the move was unsuccessful.
                return false
            }
            // Remove the piece that has been captured from the array.
            self.pieceList.remove(at: captureIndex)
        // The castling case. The castling move details are contained in the enum.
        case .castle(let castling):
            // First, find the place of the king and rook pieces in the `pieceList` array.
            let maybeKingIndex = self.pieceList.firstIndex(where: { $0.data.square == castling.kingStart })
            let maybeRookIndex = self.pieceList.firstIndex(where: { $0.data.square == castling.rookStart })
            guard let kingIndex = maybeKingIndex, let rookIndex = maybeRookIndex else {
                // If either piece is not found, then the move was unsuccessful.
                return false
            }
            // Then, edit the `square` attributes to move the identifiable king and rook pieces.
            self.pieceList[kingIndex].data.square = castling.kingEnd
            self.pieceList[rookIndex].data.square = castling.rookEnd
        }

        // At the end of the method, if this is reached, the move was successful.
        return true
    }

    /// When the position represented by the `Chessboard` is directly set to a position,
    /// no animation can be intuitively derived. Instead, all the pieces in `pieceList` are generated again.
    func setPosition(position: Position) {
        self.board = Board(position: position)
        self.pieceList = position.pieces.map({ ChessPiece(data: $0) })
    }
}
