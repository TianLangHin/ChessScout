//
//  FavouriteOpenings.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

struct FavouriteOpenings: Saveable {
    typealias IdentifiableOpening = IdWrapper<NamedOpeningLine>
    private static let saveKey = "favouriteOpenings"

    var openings: [IdentifiableOpening]

    static func readFromStore() -> Self? {
        let jsonDecoder = JSONDecoder()
        guard let storedValue = UserDefaults.standard.value(forKey: saveKey) as? Data else {
            return nil
        }
        guard let data = try? jsonDecoder.decode([NamedOpeningLine].self, from: storedValue) else {
            return nil
        }
        return FavouriteOpenings(openings: data.map({ IdWrapper(data: $0) }))
    }

    func saveToStore() {
        let jsonEncoder = JSONEncoder()
        let openingData = self.openings.map({ $0.data })
        if let encodedData = try? jsonEncoder.encode(openingData) {
            UserDefaults.standard.set(encodedData, forKey: Self.saveKey)
        }
    }

    mutating func addOpening(opening: NamedOpeningLine) {
        if self.openings.first(where: { $0.data == opening }) == nil {
            self.openings.append(IdWrapper(data: opening))
        }
    }

    mutating func removeOpenings(at offsets: IndexSet) {
        self.openings.remove(atOffsets: offsets)
    }

    mutating func moveOpenings(from source: IndexSet, to destination: Int) {
        self.openings.move(fromOffsets: source, toOffset: destination)
    }
}
