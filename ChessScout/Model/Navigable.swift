//
//  Navigable.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 22/8/2025.
//

import SwiftUI

protocol Navigable<State, Transition>: View {
    associatedtype State
    associatedtype Transition
    
    func getState() -> State

    @discardableResult
    func setState(state: State) -> Bool

    @discardableResult
    func makeTransition(transition: Transition) -> Bool
}
