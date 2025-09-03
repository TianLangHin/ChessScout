//
//  OpeningNamesFetcher.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import ChessKit
import Foundation

/// The `OpeningNamesFetcher` struct conforms to the `APIFetchable` protocol,
/// as it implements the ability to fetch opening names and opening lines from external Lichess GitHub files.
struct OpeningNamesFetcher: APIFetchable {
    /// Dedicated structs are used to represent the query parameters and the data returned.
    /// These satisfy the generic associated types required by the protocol.
    typealias Parameters = OpeningBook
    typealias FetchedData = [NamedOpeningLine]

    /// Implemented to conform to the `APIFetchable` protocol.
    func fetch(_ openingBook: Parameters) async -> FetchedData? {
        // Since this is not an official API, but rather an external data store,
        // the parameters affect the external filename instead.
        let url = "https://raw.githubusercontent.com/lichess-org/chess-openings/refs/heads/master/\(openingBook).tsv"

        // Next, the text data at the URL (if valid) is retrieved.
        // If the URL is invalid, the request fails, or the data is not a valid string, then the API call has failed.
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

        // Finally, the rows of the TSV are converted into a `NamedOpeningLine` instance for display and storage.
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
