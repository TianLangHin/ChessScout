//
//  FavouriteOpenings.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

/// The `FavouriteOpenings` model is used to store the list of openings marked as favourite by the user
/// in persistent memory. It conforms to the `Saveable` protocol and utilises UserDefaults to store the openings.
struct FavouriteOpenings: Saveable {
    typealias IdentifiableOpening = IdWrapper<NamedOpeningLine>
    /// This key is the one used for saving into UserDefaults.
    private static let saveKey = "favouriteOpenings"

    /// For display in a `List` in SwiftUI, the publicly accessible array of openings
    /// is generated such that each element is `Identifiable`.
    var openings: [IdentifiableOpening]

    /// Implemented to conform to the `Saveable` protocol.
    static func readFromStore() -> Self? {
        // Internally, this struct uses JSON to store openings in persistent memory.
        let jsonDecoder = JSONDecoder()
        // First attempt to read the JSON data from UserDefaults. Return `nil` if not possible.
        guard let storedValue = UserDefaults.standard.value(forKey: saveKey) as? Data else {
            return nil
        }
        // Then attempt to decode the data via the `JSONDecoder` into an `Array<NamedOpeningLine>` instance.
        guard let data = try? jsonDecoder.decode([NamedOpeningLine].self, from: storedValue) else {
            // Return `nil` if the decoding failed.
            return nil
        }
        // Wrap each of these inside a `IdWrapper<NamedOpeningLine>` instance to make the openings
        // easily displayable in a `List` element.
        return FavouriteOpenings(openings: data.map({ IdentifiableOpening(data: $0) }))
    }

    /// Implemented to conform to the `Saveable` protocol.
    func saveToStore() {
        // The data is saved as JSON into UserDefaults.
        let jsonEncoder = JSONEncoder()
        let openingData = self.openings.map({ $0.data })
        if let encodedData = try? jsonEncoder.encode(openingData) {
            // The final write to UserDefaults only happens if the data could be encoded successfully.
            UserDefaults.standard.set(encodedData, forKey: Self.saveKey)
        }
        // Otherwise, do nothing and do not crash the app.
    }

    /// Additional method to add an opening to the persistent favourite opening store.
    mutating func addOpening(opening: NamedOpeningLine) {
        // It only adds the opening if it does not already exist in the favourites list.
        if self.openings.first(where: { $0.data == opening }) == nil {
            self.openings.append(IdentifiableOpening(data: opening))
        }
    }

    /// Additional method to remove openings from a particular `IndexSet`,
    /// allowing `onDelete` functionality in a `List`.
    mutating func removeOpenings(at offsets: IndexSet) {
        self.openings.remove(atOffsets: offsets)
    }
}
