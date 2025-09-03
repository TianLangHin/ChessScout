//
//  Saveable.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 27/8/2025.
//

/// This protocol is to be conformed to by data that can be saved to persistent memory such as UserDefaults.
protocol Saveable {
    /// `readFromStore` is a special case of a fallible constructor,
    /// where it reads from the dedicated memory to return the saved data.
    static func readFromStore() -> Self?

    /// Given an instance of `Saveable` data, `saveToStore` writes that data
    /// to the persistent memory being used in the implementation of this class.
    func saveToStore()
}
