//
//  FavouriteOpeningsViewModel.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

class FavouriteOpeningsViewModel: ObservableObject {
    @Published var favourites: [NamedOpeningLine]
    
    init() {
        // TODO: Implement loading from UserDefaults here
        self.favourites = []
    }
}
