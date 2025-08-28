//
//  LichessOpeningFetcher.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 24/8/2025.
//

import ChessKit
import Foundation

struct LichessOpeningFetcher: APIFetchable {
    typealias Parameters = LichessOpeningQuery
    typealias FetchedData = LichessOpeningData

    func fetch(_ parameters: Parameters) async -> FetchedData? {
        let db = parameters.openingDatabase.rawValue
        let endpoint = "https://explorer.lichess.ovh/\(db)"
        let queryItems = switch parameters.openingPath {
        case .moves(let moveList):
            moveList.isEmpty ? nil : URLQueryItem(name: "play", value: moveList.map({ $0.uci() }).joined(separator: ","))
        case .position(let position):
            URLQueryItem(name: "fen", value: position.fen)
        }
        var requestUrl = URLComponents(string: endpoint)!
        if let items = queryItems {
            requestUrl.queryItems = [items]
        }

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
        data.moves.sort(by: { m1, m2 in
            let plays1 = m1.white + m1.draws + m1.black
            let plays2 = m2.white + m2.draws + m2.black
            return plays1 > plays2
        })
        return data
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

