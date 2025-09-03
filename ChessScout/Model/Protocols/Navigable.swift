//
//  Navigable.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 22/8/2025.
//

import SwiftUI

/// This protocol is to be conformed to by a SwiftUI View that is reused in multiple app scenes.
/// It represents the functionality of being able to navigate through a history of changes in the view,
/// potentially allowing animations in between to be displayed.
/// This navigation means it can be manipulated conceptually in terms of forward movements and jumps to a certain state.
///
/// Each such view will have its own representation of the view's simplified state (`GameState`),
/// and also a representation of a forward movement (`Transition`).
protocol Navigable<GameState, Transition>: View {
    associatedtype GameState
    associatedtype Transition

    /// At any point, the state of the View can be summarised by a `GameState` instance.
    /// Hence, `getState` should return this state.
    func getState() -> GameState

    /// The View should also support functionality to jump to a certain state,
    /// which is represented by a `GameState`. `setState` will set the View and its values to reflect this change.
    mutating func setState(_: GameState)

    /// There will be a starting state for the View, which can be jumped to using `resetState`.
    mutating func resetState()

    /// The `makeTransition` method executes the conceptual forward movement within the state of the View.
    /// It can potentially fail, hence returning a `Bool` indicating success of transition.
    /// However, not all scenarios will require using this return value, hence it is marked as a discardable result.
    @discardableResult
    mutating func makeTransition(_: Transition) -> Bool
}
