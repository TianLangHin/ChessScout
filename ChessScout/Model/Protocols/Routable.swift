//
//  Routable.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 28/8/2025.
//

import SwiftUI

protocol Routable {
    associatedtype Indicator
    associatedtype PossibleState: View

    func getView(_ indicator: Indicator, path: Binding<[Indicator]>) -> PossibleState
}
