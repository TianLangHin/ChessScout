//
//  OpeningNamesFetcher.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import ChessKit
import Foundation

struct OpeningNamesFetcher: APIFetchable {
    typealias Parameters = OpeningBook
    typealias FetchedData = [NamedOpeningLine]

    func fetch(_ openingBook: Parameters) async -> FetchedData? {
        let url = "https://raw.githubusercontent.com/lichess-org/chess-openings/refs/heads/master/\(openingBook).tsv"
        guard let validUrl = URL(string: url) else {
            return nil
        }
        let response = try? await URLSession.shared.data(from: validUrl)
        guard let (data, _) = response else {
            return nil
        }
        guard let text = String(data: data, encoding: String.Encoding.utf8) else {
            return nil
        }

        return text
            .split(separator: "\n")[1...]
            .map({ $0.split(separator: "\t") })
            .filter({ $0.count == 3 })
            .map({ entry in
                let eco = String(entry[0])
                let line = String(entry[1])
                let sequence = String(entry[2])
                    .split(separator: /\s+/)
                    .filter({ $0.wholeMatch(of: /\d+[.]/) == nil })
                    .map { String($0) }
                return NamedOpeningLine(eco: eco, line: line, moves: sequence)
            })
    }
}

enum OpeningBook: String {
    case a, b, c, d, e

    static func from(number: Int) -> Self? {
        switch number {
        case 0:
            return .a
        case 1:
            return .b
        case 2:
            return .c
        case 3:
            return .d
        case 4:
            return .e
        default:
            return nil
        }
    }
}

struct NamedOpeningLine: Codable, Hashable {
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
