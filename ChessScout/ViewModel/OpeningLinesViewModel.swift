//
//  OpeningLinesViewModel.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

/// This ViewModel handles the storage of a set of openings from which
/// either a list is to be displayed or a random opening is to be drawn from.
/// It supports loading from both the external ECO database as well as the favourites stored in persistent memory.
/// It conforms to `ObservableObject` since it can be used as an `EnvironmentObject` to be passed to Views implicitly.
class OpeningLinesViewModel: ObservableObject {
    @Published var openingLines: [NamedOpeningLine] = []

    let openingNamesFetcher = OpeningNamesFetcher()

    // The next two functions are implemented such that loading openings
    // using two different methods is allowed.

    // This allows openings to be loaded from external ECO opening books.
    func loadOpenings(ecos: [OpeningBook]) async {
        for openingBook in ecos {
            if let openings = await openingNamesFetcher.fetch(openingBook) {
                // Using MainActor here ensures published changes are not done outside of the main thread.
                await MainActor.run {
                    // It filters out ECO codes ending in "00", are they are unreliable/unusual openings.
                    openingLines.append(contentsOf: openings.filter({ !$0.eco.contains("00") }))
                }
            }
        }
    }

    // This allows openings to be loaded directly from a persistent favourites list.
    func loadOpenings(favourites: [NamedOpeningLine]) async {
        // Using MainActor here ensures published changes are not done outside of the main thread.
        await MainActor.run {
            openingLines = favourites
        }
    }

    // Used for the game functionality. With the loaded openings in memory, it grabs a random one and returns it.
    func getRandomOpening() -> NamedOpeningLine {
        let randomIndex = Int.random(in: 0..<self.openingLines.count)
        return self.openingLines[randomIndex]
    }

    // Used for opening selection functionality.
    // If a query string is empty, returns all lines. Otherwise, it returns one that
    // matches the query with a subsequence, either in the opening name or the ECO code.
    func filterOn(query: String) -> [NamedOpeningLine] {
        if query == "" {
            return self.openingLines
        } else {
            // All strings are set to lowercase here for user convenience.
            return self.openingLines.filter({
                isSubSequence(query: query.lowercased(), string: $0.line.lowercased()) ||
                isSubSequence(query: query.lowercased(), string: $0.eco.lowercased())
            })
        }
    }

    // Used for checking whether a query string is a subsequence of another larger string.
    // This is best suited for fuzzy-finding.
    private func isSubSequence(query: String, string: String) -> Bool {
        let queryLength = query.count
        let stringLength = string.count
        let queryStart = query.startIndex
        let stringStart = string.startIndex
        var i = 0
        var j = 0
        while i < queryLength && j < stringLength {
            let charAtQuery = query.index(queryStart, offsetBy: i)
            let charAtString = string.index(stringStart, offsetBy: j)
            if query[charAtQuery] == string[charAtString] {
                i += 1
            }
            j += 1
        }
        return i == queryLength
    }
}
