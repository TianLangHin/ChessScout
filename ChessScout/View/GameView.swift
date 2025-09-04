//
//  GameView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import ChessKit
import SwiftUI

/// This View is where the main action of any opening revision game occurs.
/// It draws random openings from the supplied list of openings,
/// prompting the user to type in which move they believe is the correct follow-up.
/// The user gets clues from the opening line history and the name of the opening.
struct GameView: View {
    // Since this View is reached via programmatic navigation,
    // the list of openings from which it draws is passed as an EnvironmentObject.
    @EnvironmentObject var openingLines: OpeningLinesViewModel

    // The game logic itself is abstracted away into a ViewModel that is local to this View.
    @ObservedObject var gameHandler: GameViewModel = GameViewModel()

    // Since this View will programmatically navigate out to another View,
    // it also needs to access a binding of the array that governs the navigation stack.
    @Binding var path: [GameRouterViewModel.Indicator]

    // This information needs to be passed explicitly upon instantiation of this View,
    // so that it knows how many times to prompt the user with a random opening.
    @State var rounds: Int

    // Since this View needs to show chess positions visually,
    // it contains a single instance of a ChessboardView
    // which can be manipulated with animations due to the Navigable protocol abstraction.
    @State var boardView = ChessboardView()

    // The user will have to enter moves explicitly before advancing to the next question,
    // so this state governs which phase of the game is currently active.
    @State var canAdvance = false

    // This state keeps the contents of the TextField through which the user enters the guessed move.
    @State var inputAnswer = ""

    // This will be used during question advancement to indicate whether the user was correct,
    // as well as a generic prompt during the time when the user needs to enter a move.
    @State var message = "What is the correct move?"

    var body: some View {
        VStack {
            // The current status of the game is shown at the top for an intuitive indicator.
            HStack {
                Text("Score: \(gameHandler.score)")
                    .fontWeight(.bold)
                Spacer()
                Text("Round: \(gameHandler.currentRound)/\(gameHandler.maxRounds)")
                    .fontWeight(.bold)
            }

            // Just under that, at the top and centre of the View, the opening prompt is shown.
            Text("\(gameHandler.opening.eco): \(gameHandler.opening.line)")
                .font(.callout)
            Text("\(gameHandler.revealedLine.joined(separator: " "))")
                .font(.footnote)
            Text("It is \(gameHandler.isWhiteToMove ? "white" : "black") to move.")
                .fontWeight(.bold)
            Text("\(message)")

            // The instantiated child ChessboardView is displayed right below the opening prompt.
            boardView

            // As much space as possible is placed in between the TextField and the ChessboardView
            // so that all of the UI space is used, without making the game feel cluttered.
            Spacer()

            // The main controls of the game are thus at the bottom of the UI,
            // with padding to ensure it does not look cropped accidentally.
            HStack {
                // The user must enter their guessed move in algebraic notation,
                // since this app is designed for people with pre-existing chess knowledge.
                // Additionally, chess notation does not align with typical sentence structure,
                // so any autocorrection or autocapitalisation is disabled.
                TextField("Enter your answer here", text: $inputAnswer)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onSubmit {
                        submitAnswer()
                    }
                Spacer()
                // The user must then either press ENTER or press this button to submit their answer.
                // To allow sufficient time to show the correct move animation,
                // the next question is not loaded immediately, but rather only after this button is clicked again.
                // Hence, the functionality of this button is governed by this logic,
                // which is represented by the value of the `canAdvance` UI state variable.
                Button {
                    if canAdvance {
                        advanceQuestion()
                    } else {
                        submitAnswer()
                    }
                } label: {
                    HStack {
                        // The condition logic of the button is reflected through its body text,
                        // with an additional indicator if it is the final question of the game.
                        if canAdvance {
                            Text(gameHandler.isFinalAdvancement ? "Finish Game" : "Next Question")
                        } else {
                            Text("Confirm Answer")
                        }
                        // A right-facing chevron is also used to indicate progression in the UI.
                        Image(systemName: "chevron.right")
                    }
                }
            }
            .padding()
        }
        .padding()
        .onAppear {
            // When the View first loads, it should immediately load the first opening prompt.
            let firstOpening = openingLines.getRandomOpening()
            gameHandler.initialise(rounds: rounds, opening: firstOpening)
            setupBoard(opening: firstOpening)
        }
        .onChange(of: gameHandler.isGameOver) {
            // Additionally, if the game has ended (indicated by the `gameHander`),
            // then the View will automatically progress to the score view.
            if gameHandler.isGameOver {
                path.append(.score(gameHandler.score, gameHandler.maxRounds))
            }
        }
    }

    /// Utility function to set the board for a particular random opening prompt.
    func setupBoard(opening: NamedOpeningLine) {
        boardView.resetState()
        if let line = opening.makePlayableLine() {
            // It does not show the final move in the line, since that is the move to be guessed.
            for move in line.dropLast() {
                boardView.makeTransition(move)
            }
        }
    }

    /// This function is executed when the user enters a move after being prompted.
    func submitAnswer() {
        // Records the correct answer.
        let answer: String
        // The below handles the case where the game logic finds that there does not exist
        // a correct answer due to the opening line being too short.
        // In that case, any option is correct.
        if gameHandler.isCorrectAnswer(given: inputAnswer) || gameHandler.correctAnswer == nil {
            answer = inputAnswer
            gameHandler.incrementScore()
            message = "You are correct!"
        } else {
            // Safe, because `nil` is covered in the previous branch.
            answer = gameHandler.correctAnswer!
            message = "The answer was \(answer)."
        }
        // Finally, make the correct move on the board by updating the chessboard UI element.
        if let move = Move(san: answer, position: boardView.getState()) {
            boardView.makeTransition(move)
        }
        // During the answering phase, the player cannot advance the question to load a new opening.
        // Now that an answer has been submitted, this is now true and thus `canAdvance` is set to true.
        canAdvance = true
    }

    /// This refreshes the opening prompt, and should only be triggered after the correct move animation is played.
    func advanceQuestion() {
        // Here, a new opening is randomly generated using the `openingLines` ViewModel.
        let newOpening = openingLines.getRandomOpening()
        // Then, the opening position is displayed, with the message prompt being set back to a question.
        setupBoard(opening: newOpening)
        gameHandler.refreshOpening(opening: newOpening)
        gameHandler.advanceRound()
        message = "What is the correct move?"
        // Additionally, the input TextField is cleared, and the game phase is reset back.
        // That is, `canAdvance` is no longer true since the new opening has been prompted,
        // meaning we are now once again waiting for the user to submit an answer.
        inputAnswer = ""
        canAdvance = false
    }
}
