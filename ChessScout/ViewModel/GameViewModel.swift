//
//  GameViewModel.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 1/9/2025.
//

import SwiftUI

/// The handler of the opening revision game logic.
class GameViewModel: ObservableObject {
    // It contains the following updated information at any point in a game:
    // the maximum rounds, current score, current round, and the current opening prompt.
    @Published var maxRounds: Int
    @Published var score: Int
    @Published var currentRound: Int
    @Published var opening: NamedOpeningLine

    // The GameViewModel also provides convenient computed properties
    // for the View to handle the game logic easily.

    // The answer that the user input should be matched against.
    var correctAnswer: String? {
        self.opening.moves.last
    }

    // The opening line that is tested, with the answer not shown (last element is to be guessed).
    var revealedLine: [String] {
        self.opening.moves.dropLast()
    }

    // Provides an indicator to the user of which side to guess for (White or Black).
    var isWhiteToMove: Bool {
        self.revealedLine.count % 2 == 0
    }

    // Provides a value to notify the GameView when to move to the GameScoreView.
    var isGameOver: Bool {
        self.currentRound == self.maxRounds + 1
    }

    // Provides a value to notify the GameView when to indicate that it is currently the last round.
    var isFinalAdvancement: Bool {
        self.currentRound == self.maxRounds
    }

    // The initialiser sets all property to default (empty) values,
    // but this is immediately overwritten upon the loading of the GameView.
    init() {
        self.opening = NamedOpeningLine(eco: "", line: "", moves: [])
        self.maxRounds = 0
        self.score = 0
        self.currentRound = 1
    }

    // This is to be called upon the loading of the GameView,
    // so that valid values are entered into this game logic handler.
    func initialise(rounds: Int, opening: NamedOpeningLine) {
        self.opening = opening
        self.maxRounds = rounds
    }

    // Below are other utility functions to manipulate game state or check some status.

    // Returns whether a given answer is correct.
    func isCorrectAnswer(given: String) -> Bool {
        return self.correctAnswer == given
    }

    // Loads a new opening into the game handler's memory.
    func refreshOpening(opening: NamedOpeningLine) {
        self.opening = opening
    }

    // Convenience function to add 1 to the score.
    func incrementScore() {
        self.score += 1
    }
 
    // Convenience function to add 1 to the round number.
    func advanceRound() {
        self.currentRound += 1
    }
}
