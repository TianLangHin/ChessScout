//
//  Navigable.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 22/8/2025.
//

import SwiftUI

protocol Navigable<GameState, Transition>: View {
    associatedtype GameState
    associatedtype Transition
    
    func getState() -> GameState

    mutating func setState(_: GameState)

    @discardableResult
    mutating func makeTransition(_: Transition) -> Bool
}
