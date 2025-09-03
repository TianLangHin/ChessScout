//
//  IdWrapper.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 24/8/2025.
//

import Foundation

/// A generic struct to conveniently wrap any data in a container that conforms to `Identifiable`.
/// This is used to enable animations of data transformations and listing data conveniently in a `List`.
struct IdWrapper<Inner>: Identifiable {
    // It contains an automatically generated unique identifier using `UUID()`.
    let id = UUID()
    // The actual wrapped data is contained in the `data` member.
    var data: Inner
}
