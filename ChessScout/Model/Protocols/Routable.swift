//
//  Routable.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 28/8/2025.
//

import SwiftUI

/// This protocol is to be conformed to by a struct or class that governs programmatic navigation between views.
/// It defines behaviour for the class such that it can provide a bindable array to a `NavigationStack`
/// where each element of that array represents a certain View.
///
/// Each such implementation must provide a custom `Indicator` associated type,
/// which is the data type used to indicate to the struct/class what kind of view to output.
/// It will also always output a certain View instance, which is represented by `PossibleState`.
protocol Routable<Indicator, PossibleState> where PossibleState: View {
    associatedtype Indicator
    // `PossibleState` is not to be manually declared by the concrete struct/class
    // that conforms to `Routable`. It is instead for compatibility with Swift's type checker and ViewBuilder.
    associatedtype PossibleState

    /// Given a particular indicator, `getView` will generate and return the correct View instance
    /// determined by the custom logic and structure of the `Indicator`.
    /// Since these views may need access to the array attached to the `NavigationStack`,
    /// this is also required as a `path` parameter.
    func getView(_ indicator: Indicator, path: Binding<[Indicator]>) -> PossibleState
}
