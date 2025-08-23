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
    @State var history: [Position] = []

    @State var boardView = ChessboardView()

    var body: some View {
        VStack {
            Text("ChessScout")
                .font(.title)
                .padding()
            boardView
            VStack {
                TextField("Enter move here", text: $moveText)
                    .textInputAutocapitalization(.never)
                    .padding()
                HStack {
                    Button {
                        let move = Move(san: moveText, position: boardView.getState())
                        if let validMove = move {
                            boardView.makeTransition(validMove)
                            moveText = ""
                            history.append(boardView.getState())
                        }
                    } label: {
                        Text("Make Move")
                    }
                    Spacer()
                    Button {
                        if history.popLast() != nil {
                            boardView.setState(history.last ?? .standard)
                        }
                    } label: {
                        Text("Undo Move")
                    }
                }
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
