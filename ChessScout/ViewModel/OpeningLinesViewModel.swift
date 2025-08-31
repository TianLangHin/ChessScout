//
//  OpeningLinesViewModel.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

class OpeningLinesViewModel: ObservableObject {
    @Published var openingLines: [NamedOpeningLine] = []
    
    let openingNamesFetcher = OpeningNamesFetcher()
    
    func loadOpenings(ecos: [OpeningBook]) async {
        for openingBook in ecos {
            if let openings = await openingNamesFetcher.fetch(openingBook) {
                openingLines.append(contentsOf: openings.filter({ !$0.eco.contains("00") }))
            }
        }
    }
    
    func loadOpenings(favourites: [NamedOpeningLine]) async {
        openingLines = favourites
    }

    func getRandomOpening() -> NamedOpeningLine {
        let randomIndex = Int.random(in: 0..<self.openingLines.count)
        return self.openingLines[randomIndex]
    }

    func filterOn(query: String) -> [NamedOpeningLine] {
        if query == "" {
            return self.openingLines
        } else {
            return self.openingLines.filter({
                isSubSequence(query: query.lowercased(), string: $0.line.lowercased()) ||
                isSubSequence(query: query.lowercased(), string: $0.eco.lowercased())
            })
        }
    }

    private func isSubSequence(query: String, string: String) -> Bool {
        let queryLength = query.count
        let stringLength = string.count
        let queryStart = query.startIndex
        let stringStart = string.startIndex
        var i = 0
        var j = 0
        while i < queryLength && j < stringLength {
            let charAtQuery = query.index(queryStart, offsetBy: i)
            let charAtString = string.index(stringStart, offsetBy: i)
            if query[charAtQuery] == string[charAtString] {
                i += 1
            }
            j += 1
        }
        return i == queryLength
    }
}
