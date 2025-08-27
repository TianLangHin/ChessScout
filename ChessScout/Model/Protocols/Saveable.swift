//
//  Saveable.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 27/8/2025.
//

protocol Saveable: Codable {
    func read() -> Self
    func save(_: Self)
}
