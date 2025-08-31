//
//  FavouriteOpeningsViewModel.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

class FavouriteOpeningsViewModel: ObservableObject {
    typealias IdentifiableOpening = IdWrapper<NamedOpeningLine>
    @Published var favourites: FavouriteOpenings

    var openings: [IdentifiableOpening] {
        self.favourites.openings
    }

    init() {
        self.favourites = FavouriteOpenings.readFromStore() ?? FavouriteOpenings(openings: [])
    }

    func save() {
        self.favourites.saveToStore()
    }

    func addOpening(opening: NamedOpeningLine) {
        self.favourites.addOpening(opening: opening)
        self.save()
    }

    func removeOpenings(at offsets: IndexSet) {
        self.favourites.removeOpenings(at: offsets)
        self.save()
    }
}
