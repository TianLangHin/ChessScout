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
