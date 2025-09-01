//
//  GameView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import ChessKit
import SwiftUI

struct GameView: View {

    @EnvironmentObject var openingLines: OpeningLinesViewModel
    @ObservedObject var gameHandler: GameViewModel = GameViewModel()

    @Binding var path: [GameRouterViewModel.Indicator]
    @State var rounds: Int

    @State var chessboard = ChessboardView()
    @State var canAdvance = false
    @State var inputAnswer = ""
    @State var message = "What is the correct move?"

    var body: some View {
        VStack {
            HStack {
                Text("Score: \(gameHandler.score)")
                    .fontWeight(.bold)
                Spacer()
                Text("Round: \(gameHandler.currentRound)/\(gameHandler.maxRounds)")
                    .fontWeight(.bold)
            }
            Text("\(gameHandler.opening.eco): \(gameHandler.opening.line)")
                .font(.callout)
            Text("\(gameHandler.revealedLine.joined(separator: " "))")
                .font(.footnote)
            Text("It is \(gameHandler.isWhiteToMove ? "white" : "black") to move.")
                .fontWeight(.bold)
            Text("\(message)")
            chessboard
            Spacer()
            HStack {
                TextField("Enter your answer here", text: $inputAnswer)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onSubmit {
                        submitAnswer()
                    }
                Spacer()
                Spacer()
                Button {
                    if canAdvance {
                        advanceQuestion()
                    } else {
                        submitAnswer()
                    }
                } label: {
                    HStack {
                        if canAdvance {
                            Text(gameHandler.isFinalAdvancement ? "Finish Game" : "Next Question")
                        } else {
                            Text("Confirm Answer")
                        }
                        Image(systemName: "chevron.right")
                    }
                }
            }
        }
        .padding()
        .onAppear {
            let firstOpening = openingLines.getRandomOpening()
            gameHandler.initialise(rounds: rounds, opening: firstOpening)
            setupBoard(opening: firstOpening)
        }
        .onChange(of: gameHandler.isGameOver) {
            if gameHandler.isGameOver {
                path.append(.score(gameHandler.score, gameHandler.maxRounds))
            }
        }
    }

    func setupBoard(opening: NamedOpeningLine) {
        chessboard.resetState()
        if let line = opening.makePlayableLine() {
            for move in line.dropLast() {
                chessboard.makeTransition(move)
            }
        }
    }

    func submitAnswer() {
        let answer: String
        if gameHandler.isCorrectAnswer(given: inputAnswer) || gameHandler.correctAnswer == nil {
            answer = inputAnswer
            gameHandler.incrementScore()
            message = "You are correct!"
        } else {
            // Safe, because `nil` is covered in the previous branch.
            answer = gameHandler.correctAnswer!
            message = "The answer was \(answer)."
        }
        if let move = Move(san: answer, position: chessboard.getState()) {
            chessboard.makeTransition(move)
        }
        canAdvance = true
    }

    func advanceQuestion() {
        let newOpening = openingLines.getRandomOpening()
        setupBoard(opening: newOpening)
        gameHandler.refreshOpening(opening: newOpening)
        gameHandler.advanceRound()
        message = "What is the correct move?"
        inputAnswer = ""
        canAdvance = false
    }
}
