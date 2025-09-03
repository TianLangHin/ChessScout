//
//  ChessScoutTests.swift
//  ChessScoutTests
//
//  Created by Tian Lang Hin on 16/8/2025.
//

import ChessKit
import XCTest
@testable import ChessScout

final class ChessScoutTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    /// This test uses a simple Ruy Lopez opening sequence to test whether the `ChessBoard` class
    /// (implemented as a wrapper to keep track of piece moves in the UI) works correctly
    /// and is able to properly keep track of all board state in a basic sequence of chess moves.
    func testRuyLopezWorks() {
        let chessBoard = Chessboard()
        XCTAssertEqual(chessBoard.board.position, .standard, "Must start at initial chess position")
        let moveNotations = [
            "e4", "e5",
            "Nf3", "Nc6",
            "Bb5", "a6",
            "Ba4", "Nf6",
            "O-O"
        ]
        for moveNotation in moveNotations {
            let move = Move(san: moveNotation, position: chessBoard.board.position)
            XCTAssertNotNil(move, "The provided move sequence must be valid")
            let isMoveValid = chessBoard.makeMove(move: move!)
            XCTAssertEqual(isMoveValid, true, "Every move must be valid for the chess position")
        }
        let finalPositionFEN = "r1bqkb1r/1ppp1ppp/p1n2n2/4p3/B3P3/5N2/PPPP1PPP/RNBQ1RK1 b kq - 3 5"
        let position = Position(fen: finalPositionFEN)
        XCTAssertNotNil(position, "The given FEN is known to be valid")
        XCTAssertEqual(chessBoard.board.position, position!, "The end position must match the FEN")
        let trackedPieceSet = Set(chessBoard.pieceList.map({ $0.data }))
        let positionPieceSet = Set(position!.pieces)
        XCTAssertEqual(trackedPieceSet, positionPieceSet, "The ID-tracked piece set must match the position piece set")
    }

    /// This test uses a longer, tricky and complicated Albin Countergambit (Lasker Trap) opening sequence
    /// to test whether the `Chessboard` class works as in intended, much like the `testRuyLopezWorks` test.
    func testLaskerTrapWorks() {
        let chessBoard = Chessboard()
        XCTAssertEqual(chessBoard.board.position, .standard, "Must start at initial chess position")
        let moveNotations = [
            "d4", "d5",
            "c4", "e5",
            "dxe5", "d4",
            "e3", "Bb4+",
            "Bd2", "dxe3",
            "Bxb4", "exf2+",
            "Ke2", "fxg1=N+",
            "Ke1", "Qh4+",
            "g3", "Qe4+",
            "Be2", "Qxh1"
        ]
        for moveNotation in moveNotations {
            let move = Move(san: moveNotation, position: chessBoard.board.position)
            XCTAssertNotNil(move, "The provided move sequence must be valid")
            let isMoveValid = chessBoard.makeMove(move: move!)
            XCTAssertEqual(isMoveValid, true, "Every move must be valid for the chess position")
        }
        let finalPositionFEN = "rnb1k1nr/ppp2ppp/8/4P3/1BP5/6P1/PP2B2P/RN1QK1nq w kq - 0 11"
        let position = Position(fen: finalPositionFEN)
        XCTAssertNotNil(position, "The given FEN is known to be valid")
        XCTAssertEqual(chessBoard.board.position, position!, "The end position must match the FEN")
        let trackedPieceSet = Set(chessBoard.pieceList.map({ $0.data }))
        let positionPieceSet = Set(position!.pieces)
        XCTAssertEqual(trackedPieceSet, positionPieceSet, "The ID-tracked piece set must match the position piece set")
    }

    /// This test uses a short opening sequence consisting of en passant captures
    /// to test whether the `Chessboard` class works as in intended, much like the `testRuyLopezWorks` test.
    func testEnPassantWorks() {
        let chessBoard = Chessboard()
        XCTAssertEqual(chessBoard.board.position, .standard, "Must start at initial chess position")
        let moveNotations = [
            "e4", "c5",
            "e5", "d5",
            "exd6", "c4",
            "d4", "cxd3"
        ]
        for moveNotation in moveNotations {
            let move = Move(san: moveNotation, position: chessBoard.board.position)
            XCTAssertNotNil(move, "The provided move sequence must be valid")
            let isMoveValid = chessBoard.makeMove(move: move!)
            XCTAssertEqual(isMoveValid, true, "Every move must be valid for the chess position")
        }
        let finalPositionFEN = "rnbqkbnr/pp2pppp/3P4/8/8/3p4/PPP2PPP/RNBQKBNR w KQkq d3 1 5"
        let position = Position(fen: finalPositionFEN)
        XCTAssertNotNil(position, "The given FEN is known to be valid")
        XCTAssertEqual(chessBoard.board.position, position!, "The end position must match the FEN")
        let trackedPieceSet = Set(chessBoard.pieceList.map({ $0.data }))
        let positionPieceSet = Set(position!.pieces)
        XCTAssertEqual(trackedPieceSet, positionPieceSet, "The ID-tracked piece set must match the position piece set")
    }

    /// This test checks whether a position can be directly set using `setPosition` in a `Chessboard` instance
    /// and preserve the correctness of all piece locations when tracking for UI usage.
    func testSetPositionWorks() {
        let fenList = [
            "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
            "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1",
            "rnbqkbnr/pp1ppppp/8/2p5/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2",
            "rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2",
            "rnbqkbnr/pp2pppp/3p4/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 0 3",
            "rnbqkbnr/pp2pppp/3p4/2p5/3PP3/5N2/PPP2PPP/RNBQKB1R b KQkq - 0 3",
            "rnbqkbnr/pp2pppp/3p4/8/3pP3/5N2/PPP2PPP/RNBQKB1R w KQkq - 0 4",
            "rnbqkbnr/pp2pppp/3p4/8/3NP3/8/PPP2PPP/RNBQKB1R b KQkq - 0 4",
            "rnbqkb1r/pp2pppp/3p1n2/8/3NP3/8/PPP2PPP/RNBQKB1R w KQkq - 1 5",
            "rnbqkb1r/pp2pppp/3p1n2/8/3NP3/2N5/PPP2PPP/R1BQKB1R b KQkq - 2 5",
            "rnbqkb1r/1p2pppp/p2p1n2/8/3NP3/2N5/PPP2PPP/R1BQKB1R w KQkq - 0 6"
        ]
        let chessBoard = Chessboard()
        for fen in fenList {
            let position = Position(fen: fen)
            XCTAssertNotNil(position, "The given FEN is known to be valid")
            chessBoard.setPosition(position: position!)
            let trackedPieceSet = Set(chessBoard.pieceList.map({ $0.data }))
            let positionPieceSet = Set(position!.pieces)
            XCTAssertEqual(trackedPieceSet, positionPieceSet, "The ID-tracked piece set must match the position piece set")
        }
    }

    /// Tests whether the `addOpening` method in the `FavouriteOpenings` class works correctly,
    /// preserving the order by which the openings were inserted.
    func testFavouriteOpeningsCanAddOpenings() {
        let a99 = NamedOpeningLine(
            eco: "A99",
            line: "Dutch Defense: Classical Variation, Ilyin-Zhenevsky Variation, Modern Main Line",
            moves: ["d4", "f5", "c4", "Nf6", "g3", "e6", "Bg2", "Be7", "Nf3", "O-O", "O-O", "d6", "Nc3", "Qe8", "b3"])
        let b99 = NamedOpeningLine(
            eco: "B99",
            line: "Sicilian Defense: Najdorf Variation, Main Line",
            moves: ["e4", "c5", "Nf3", "d6", "d4", "cxd4", "Nxd4", "Nf6", "Nc3", "a6", "Bg5", "e6", "f4", "Be7", "b3"])
        let c88 = NamedOpeningLine(
            eco: "C88",
            line: "Ruy Lopez: Closed, Trajkovic Counterattack",
            moves: ["e4", "c5", "Nf3", "Nc6", "Bb5", "a6", "Ba4", "Nf6", "O-O", "Be7", "Re1", "b5", "Bb3", "Bb7"])

        var favouriteOpenings = FavouriteOpenings(openings: [])
        let openings = [a99, b99, c88]
        for opening in openings {
            favouriteOpenings.addOpening(opening: opening)
        }
        let idOpeningData = favouriteOpenings.openings.map({ $0.data })
        XCTAssertEqual(idOpeningData, openings, "Openings inserted via addOpening must be preserved in order")
    }

    /// Tests whether the `addOpening` and `removeOpenings` methods in the `FavouriteOpenings` class work correctly,
    /// preserving the order by which the openings were inserted and vacating the correct array indices.
    func testFavouriteOpeningsCanPreserveOrderingAfterDelete() {
        let a99 = NamedOpeningLine(
            eco: "A99",
            line: "Dutch Defense: Classical Variation, Ilyin-Zhenevsky Variation, Modern Main Line",
            moves: ["d4", "f5", "c4", "Nf6", "g3", "e6", "Bg2", "Be7", "Nf3", "O-O", "O-O", "d6", "Nc3", "Qe8", "b3"])
        let b99 = NamedOpeningLine(
            eco: "B99",
            line: "Sicilian Defense: Najdorf Variation, Main Line",
            moves: ["e4", "c5", "Nf3", "d6", "d4", "cxd4", "Nxd4", "Nf6", "Nc3", "a6", "Bg5", "e6", "f4", "Be7", "b3"])
        let c88 = NamedOpeningLine(
            eco: "C88",
            line: "Ruy Lopez: Closed, Trajkovic Counterattack",
            moves: ["e4", "c5", "Nf3", "Nc6", "Bb5", "a6", "Ba4", "Nf6", "O-O", "Be7", "Re1", "b5", "Bb3", "Bb7"])
        let d06 = NamedOpeningLine(
            eco: "D06",
            line: "Queen's Gambit Declined: Baltic Defense, Argentinian Gambit",
            moves: ["d4", "d5", "c4", "Bf5", "cxd5", "Bxb1", "Qa4+", "c6", "dxc6", "Nxc6"])

        var favouriteOpenings = FavouriteOpenings(openings: [])
        let initialOpenings = [a99, b99, c88, d06]
        for opening in initialOpenings {
            favouriteOpenings.addOpening(opening: opening)
        }
        let initialIdOpeningData = favouriteOpenings.openings.map({ $0.data })
        XCTAssertEqual(initialIdOpeningData, initialOpenings, "Openings inserted via addOpening must be preserved in order")

        let finalOpenings = [a99, d06]
        favouriteOpenings.removeOpenings(at: IndexSet([1, 2]))
        let finalIdOpeningData = favouriteOpenings.openings.map({ $0.data })
        XCTAssertEqual(finalIdOpeningData, finalOpenings, "Openings ordering must be preserved after removal")
    }

    /// Tests whether the API call to the Lichess opening database works with a trivial query.
    func testLichessCanFetchWithEmpty() async {
        let fetcher = LichessOpeningFetcher()
        let query = LichessOpeningQuery(openingPath: .moves([]), openingDatabase: .masters)
        let results = await fetcher.fetch(query)
        XCTAssertNotNil(results, "This API call fetches openings from the start position, and should not fail")
        XCTAssertFalse(results!.moves.isEmpty, "Opening list from the start position should not be empty")
    }

    /// Tests whether the API call to the Lichess opening database works with a non-empty query.
    func testLichessCanFetchWithBasicMove() async {
        let fetcher = LichessOpeningFetcher()
        let move = Move(san: "e4", position: .standard)
        XCTAssertNotNil(move, "e4 is a valid starting move")
        let query = LichessOpeningQuery(openingPath: .moves([move!]), openingDatabase: .masters)
        let results = await fetcher.fetch(query)
        XCTAssertNotNil(results, "This API call fetches openings from the 1. e4 position, and should not fail")
        XCTAssertFalse(results!.moves.isEmpty, "Opening list from the 1. e4 position should not be empty")
    }

    /// Tests whether the external call to the opening book repository (hosted on GitHub)
    /// can retrieve information reliably.
    func testOpeningBooksCanFetchAll() async {
        let books: [OpeningBook] = [.a, .b, .c, .d, .e]
        let fetcher = OpeningNamesFetcher()
        for book in books {
            let data = await fetcher.fetch(book)
            XCTAssertNotNil(data, "The opening book (\(book.rawValue)) should exist in the external repository")
            XCTAssertFalse(data!.isEmpty, "The external data file (book \(book.rawValue)) should not be empty")
        }
    }
}
