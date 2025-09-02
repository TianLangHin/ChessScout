//
//  GameViewModel.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 1/9/2025.
//

import SwiftUI

class GameViewModel: ObservableObject {

    @Published var maxRounds: Int
    @Published var score: Int
    @Published var currentRound: Int
    @Published var opening: NamedOpeningLine

    var correctAnswer: String? {
        self.opening.moves.last
    }

    var revealedLine: [String] {
        self.opening.moves.dropLast()
    }

    var isWhiteToMove: Bool {
        self.revealedLine.count % 2 == 0
    }

    var isGameOver: Bool {
        self.currentRound == self.maxRounds + 1
    }

    var isFinalAdvancement: Bool {
        self.currentRound == self.maxRounds
    }

    init() {
        self.opening = NamedOpeningLine(eco: "", line: "", moves: [])
        self.maxRounds = 0
        self.score = 0
        self.currentRound = 1
    }

    func initialise(rounds: Int, opening: NamedOpeningLine) {
        self.opening = opening
        self.maxRounds = rounds
    }

    func isCorrectAnswer(given: String) -> Bool {
        return self.correctAnswer == given
    }

    func refreshOpening(opening: NamedOpeningLine) {
        self.opening = opening
    }

    func incrementScore() {
        self.score += 1
    }
 
    func advanceRound() {
        self.currentRound += 1
    }
}
