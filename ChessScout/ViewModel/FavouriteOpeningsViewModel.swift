//
//  FavouriteOpeningsViewModel.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

class FavouriteOpeningsViewModel: ObservableObject {
    @Published var favourites: FavouriteOpenings

    var openings: [NamedOpeningLine] {
        self.favourites.openings
    }

    init() {
        self.favourites = FavouriteOpenings.readFromStore() ?? FavouriteOpenings(openings: [])
    }

    func save() {
        self.favourites.saveToStore()
    }
}
