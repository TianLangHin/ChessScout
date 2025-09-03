//
//  LichessOpeningFetcher.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 24/8/2025.
//

import ChessKit
import Foundation

/// The `LichessOpeningFetcher` struct conforms to the `APIFetchable` protocol,
/// and is dedicated to fetching the opening statistics from the official Lichess API.
struct LichessOpeningFetcher: APIFetchable {
    /// Dedicated structs are used to represent the URL query parameters used for the API,
    /// and also the data being returned. These satisfy the generic associated types required by the protocol.
    typealias Parameters = LichessOpeningQuery
    typealias FetchedData = LichessOpeningData

    /// Implemented to conform to the `APIFetchable` protocol.
    func fetch(_ parameters: Parameters) async -> FetchedData? {
        // The endpoint of the query depends on the database that is fetched (either "masters" or "casual").
        let db = parameters.openingDatabase.rawValue
        let endpoint = "https://explorer.lichess.ovh/\(db)"

        // The query parameters can either be a list of moves or a position FEN, as required by the Lichess API.
        let queryItems = switch parameters.openingPath {
        case .moves(let moveList):
            // If the list of moves passed to the `fetch` function is empty, then the query parameter should be empty.
            // The name of the query parameter in this case is "play".
            moveList.isEmpty ? nil : URLQueryItem(name: "play", value: moveList.map({ $0.uci() }).joined(separator: ","))
        case .position(let position):
            // The name of the query parameter for setting positions is "fen".
            URLQueryItem(name: "fen", value: position.fen)
        }

        // Then, the endpoint URL is combined with the query parameters if there are any.
        var requestUrl = URLComponents(string: endpoint)!
        if let items = queryItems {
            requestUrl.queryItems = [items]
        }

        // Next, the query is made. If the URL is malformed, the query does not return valid data,
        // or the data does not conform to the known API structure, then this call fails and returns `nil`.
        let jsonDecoder = JSONDecoder()
        guard let validUrl = requestUrl.url else {
            return nil
        }
        let response = try? await URLSession.shared.data(from: validUrl)
        guard let (rawData, _) = response else {
            return nil
        }
        guard var data = try? jsonDecoder.decode(FetchedData.self, from: rawData) else {
            return nil
        }

        // Finally, if the query is successful, it is sorted in descending order based on the move frequency.
        data.moves.sort(by: { m1, m2 in
            let plays1 = m1.white + m1.draws + m1.black
            let plays2 = m2.white + m2.draws + m2.black
            return plays1 > plays2
        })
        return data
    }
}

struct LichessOpeningQuery {
    let openingPath: LichessOpeningQuery.OpeningPath
    let openingDatabase: LichessOpeningQuery.OpeningDatabase

    enum OpeningPath {
        case moves([Move])
        case position(Position)
    }

    enum OpeningDatabase: String {
        case masters = "masters"
        case casual = "lichess"
    }
}

struct LichessOpeningData: Decodable {
    let white: Int
    let draws: Int
    let black: Int
    var moves: [LichessOpeningData.MoveStats]
    let opening: LichessOpeningData.OpeningInfo?

    public struct MoveStats: Decodable {
        let white: Int
        let draws: Int
        let black: Int
        let san: String
        let averageRating: Int
    }

    public struct OpeningInfo: Decodable {
        let eco: String
        let name: String
    }
}
