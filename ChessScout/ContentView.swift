//
//  ContentView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 16/8/2025.
//

import ChessKit
import SwiftUI

struct ContentView: View {

    @State var moveText = ""
    @State var fenText = ""

    @State var boardView = ChessboardView()

    var body: some View {
        VStack {
            boardView
            Spacer()
            TextField("Enter move here", text: $moveText)
                .textInputAutocapitalization(.never)
            Button {
                let move = Move(san: moveText, position: boardView.getState())
                if let validMove = move {
                    boardView.makeTransition(validMove)
                }
            } label: {
                Text("Make Move")
            }
            Spacer()
            TextField("Enter FEN here instead", text: $fenText)
                .textInputAutocapitalization(.never)
            Button {
                let pos = Position(fen: fenText)
                if let validFen = pos {
                    boardView.setState(validFen)
                }
            } label: {
                Text("Set FEN")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
