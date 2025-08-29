//
//  FavouriteOpenings.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

struct FavouriteOpenings: Saveable {
    private static let saveKey = "favouriteOpenings"
    
    var openings: [NamedOpeningLine]

    static func readFromStore() -> Self? {
        let jsonDecoder = JSONDecoder()
        guard let storedValue = UserDefaults.standard.value(forKey: saveKey) as? Data else {
            return nil
        }
        guard let data = try? jsonDecoder.decode([NamedOpeningLine].self, from: storedValue) else {
            return nil
        }
        return FavouriteOpenings(openings: data)
    }

    func saveToStore() {
        let jsonEncoder = JSONEncoder()
        if let encodedData = try? jsonEncoder.encode(self) {
            UserDefaults.standard.set(encodedData, forKey: Self.saveKey)
        }
    }
}
