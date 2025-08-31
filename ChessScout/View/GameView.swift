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

    @Binding var path: [GameRouterViewModel.Indicator]
    @State var rounds: Int
    
    @State var chessboard = ChessboardView()
    @State var roundsElapsed = 0
    @State var score = 0
    @State var canAdvance = false
    @State var correctAnswer: Move? = nil
    @State var inputAnswer = ""
    @State var message = ""
    @State var openingName = ""

    var body: some View {
        VStack {
            HStack {
                Text("Score: \(score)")
                Spacer()
                Text("Round: \(roundsElapsed + 1)")
            }
            chessboard
            Text("\(openingName)")
                .padding()
            Text("\(message)")
            HStack {
                TextField("Enter your answer here", text: $inputAnswer)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .onSubmit {
                        submitAnswer()
                    }
                Spacer()
                Button {
                    if canAdvance {
                        advanceQuestion()
                    } else {
                        submitAnswer()
                    }
                } label: {
                    HStack {
                        Text(canAdvance ? "Next Question" : "Submit")
                        Image(systemName: "chevron.right")
                    }
                }
            }
        }
        .padding()
        .onAppear {
            advanceQuestion(increment: false)
        }
        .onChange(of: roundsElapsed) {
            if roundsElapsed == rounds {
                path.append(.score(score, rounds))
            }
        }
    }

    func submitAnswer() {
        let correctString = correctAnswer?.san ?? ""
        if inputAnswer == correctString {
            score += 1
            message = "You are correct!"
        } else {
            message = "The answer was \(correctString)."
        }
        if let move = correctAnswer {
            chessboard.makeTransition(move)
        }
        canAdvance = true
    }

    func advanceQuestion(increment: Bool = true) {
        let randomNumber = Int.random(in: 0..<openingLines.openingLines.count)
        setBoardByLine(index: randomNumber)
        if increment {
            roundsElapsed += 1
        }
        message = ""
        inputAnswer = ""
        canAdvance = false
    }

    func setBoardByLine(index: Int) {
        chessboard.resetState()
        let opening = openingLines.openingLines[index]
        if let line = opening.makePlayableLine() {
            openingName = "\(opening.eco): \(opening.line)\n\(line.dropLast().map({ $0.san }).joined(separator: " "))"
            for move in line.dropLast() {
                chessboard.makeTransition(move)
            }
            correctAnswer = line.last
        }
    }
}
