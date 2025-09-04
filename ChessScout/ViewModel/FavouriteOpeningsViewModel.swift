//
//  FavouriteOpeningsViewModel.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

/// This ViewModel keeps track of the user's favourite openings in a list,
/// exposing its functionality for easy usage within Views.
/// It conforms to the `ObservableObject` protocol since it will be used as an `EnvironmentObject`
/// to be passed easily between views.
class FavouriteOpeningsViewModel: ObservableObject {
    // This ViewModel uses the `FavouriteOpenings` model to keep track of logic changes.
    // This attribute is publishable so that the computed property is updated correctly as well.
    @Published var favourites: FavouriteOpenings

    // The computed property wraps the `openings` property of the inner `favourites` model property,
    // so that the view does not need to handle the model directly.
    var openings: [IdWrapper<NamedOpeningLine>] {
        self.favourites.openings
    }

    // Upon initialisation, if the read from persistent storage fails,
    // then the inner model is initialised with an empty list so the app does not crash,
    // but instead the operations can continue.
    init() {
        self.favourites = FavouriteOpenings.readFromStore() ?? FavouriteOpenings(openings: [])
    }

    // Saves to persistent storage using the model's existing functionality.
    func save() {
        self.favourites.saveToStore()
    }

    // Wraps the functionality of adding an opening to the inner model,
    // while also saving to persistent storage each time for convenience.
    func addOpening(opening: NamedOpeningLine) {
        self.favourites.addOpening(opening: opening)
        self.save()
    }

    // Wraps the functionality of deleting openings from the inner model,
    // while also saving to persistent storage each time for convenience.
    // This allows `onDelete` modifiers to work seamlessly on the favourite openings list.
    func removeOpenings(at offsets: IndexSet) {
        self.favourites.removeOpenings(at: offsets)
        self.save()
    }
}
