//
//  OpeningExplorerView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 24/8/2025.
//

import ChessKit
import SwiftUI

struct OpeningExplorerView: View {
    typealias GameState = (Move, Position)
    typealias WrappedGameState = IdWrapper<GameState>
    typealias WrappedStats = IdWrapper<LichessOpeningData.MoveStats>

    @State var openingExplorer = OpeningExplorerViewModel()
    @State var openings: [WrappedStats] = []
    @State var boardView = ChessboardView()
    @State var isLoaded = false

    var body: some View {
        VStack {
            boardView
            HStack {
                Button {
                    openingExplorer.useMastersDatabase.toggle()
                } label: {
                    if openingExplorer.useMastersDatabase {
                        Text("Masters")
                    } else {
                        Text("Casual")
                    }
                }
                .buttonStyle(.bordered)
                .frame(width: 90)
                historyLayer()
            }
            .padding()
            if !isLoaded {
                List {
                    Text("Loading Opening Data...")
                }
            } else if openings.isEmpty {
                List {
                    Text("This line was not found in the database.")
                }
            } else {
                List {
                    Section {
                        ForEach(openings) { opening in
                            let moveStats = opening.data
                            Button {
                                makeMove(moveSan: moveStats.san)
                            } label: {
                                OpeningStatView(openingStat: moveStats)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    } header: {
                        HStack {
                            Text("Move")
                            Spacer()
                            Text("White win / Draw / Black win")
                        }
                    }
                }
                .listStyle(.grouped)
            }
            HStack {
                Button {
                    moveBackward()
                } label: {
                    Image(systemName: "chevron.left")
                        .padding()
                }
                Button {
                    moveForward()
                } label: {
                    Image(systemName: "chevron.right")
                        .padding()
                }
            }
        }
        .onAppear(perform: {
            boardView.resetState()
            updateMoveList()
        })
        .onChange(of: openingExplorer.useMastersDatabase, {
            updateMoveList()
        })
    }

    private func historyLayer() -> some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(openingExplorer.history.dropLast()) { gameState in
                        Button {
                            setState(gameState: gameState)
                        } label: {
                            Text("\(gameState.data.0)")
                                .foregroundStyle(.red)
                        }
                    }
                    if let currentState = openingExplorer.history.last {
                        Button {
                            setState(gameState: currentState)
                        } label: {
                            Text("\(currentState.data.0)")
                                .foregroundStyle(.green)
                        }
                        .id(0)
                    }
                    ForEach(openingExplorer.future.reversed()) { gameState in
                        Button {
                            setState(gameState: gameState)
                        } label: {
                            Text("\(gameState.data.0)")
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
            .onChange(of: openingExplorer.history.count) {
                scrollView.scrollTo(0)
            }
        }
    }

    private func makeMove(moveSan: String, clearFuture: Bool = true) {
        if let move = Move(san: moveSan, position: boardView.getState()) {
            if boardView.makeTransition(move) {
                let newState = boardView.getState()
                openingExplorer.makeMove(move: move, newState: newState, clearFuture: clearFuture)
                updateMoveList()
            }
        }
    }

    private func moveForward() {
        if let futureState = openingExplorer.future.popLast() {
            makeMove(moveSan: futureState.data.0.san, clearFuture: false)
        }
    }

    private func moveBackward() {
        if let undoneState = openingExplorer.history.popLast() {
            openingExplorer.future.append(undoneState)
            boardView.setState(openingExplorer.history.last?.data.1 ?? .standard)
        }
        updateMoveList()
    }

    private func setState(gameState: WrappedGameState) {
        let success = openingExplorer.setState(gameState: gameState)
        if success {
            updateMoveList()
            boardView.setState(gameState.data.1)
        }
    }

    private func updateMoveList() {
        Task {
            isLoaded = false
            openings = await openingExplorer.fetch()
            isLoaded = true
        }
    }
}

#Preview {
    OpeningExplorerView()
}
