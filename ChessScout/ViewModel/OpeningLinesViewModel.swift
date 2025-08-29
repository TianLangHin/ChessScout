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
}
