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
    
    let openingFetcher = LichessOpeningFetcher()

    @State var useMastersDatabase = true
    @State var history: [WrappedGameState] = []
    @State var future: [WrappedGameState] = []
    @State var openings: [WrappedStats] = []
    @State var boardView = ChessboardView()

    @State var isLoaded = false

    var body: some View {
        VStack {
            boardView
            HStack {
                Button {
                    useMastersDatabase.toggle()
                } label: {
                    Text(useMastersDatabase ? "Masters" : "Casual")
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
                }
                Button {
                    moveForward()
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()
        }
        .onAppear(perform: {
            boardView.resetState()
            updateMoveList()
        })
        .onChange(of: useMastersDatabase, {
            updateMoveList()
        })
    }

    private func historyLayer() -> some View {
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(history.dropLast()) { gameState in
                        Button {
                            setState(gameState: gameState)
                        } label: {
                            Text("\(gameState.data.0)")
                                .foregroundStyle(.red)
                        }
                    }
                    if let currentState = history.last {
                        Button {
                            setState(gameState: currentState)
                        } label: {
                            Text("\(currentState.data.0)")
                                .foregroundStyle(.green)
                        }
                        .id(0)
                    }
                    ForEach(future.reversed()) { gameState in
                        Button {
                            setState(gameState: gameState)
                        } label: {
                            Text("\(gameState.data.0)")
                                .foregroundStyle(.blue)
                        }
                    }
                }
            }
            .onChange(of: history.count) {
                scrollView.scrollTo(0)
            }
        }
    }

    private func makeMove(moveSan: String, clearFuture: Bool = true) {
        if let move = Move(san: moveSan, position: boardView.getState()) {
            if boardView.makeTransition(move) {
                let state = (move, boardView.getState())
                history.append(WrappedGameState(data: state))
                if move == future.last?.data.0 {
                    let _ = future.popLast()
                } else if clearFuture {
                    future.removeAll()
                }
                updateMoveList()
            }
        }
    }

    private func moveForward() {
        if let futureState = future.popLast() {
            makeMove(moveSan: futureState.data.0.san, clearFuture: false)
        }
    }

    private func moveBackward() {
        if let undoneState = history.popLast() {
            future.append(undoneState)
            boardView.setState(history.last?.data.1 ?? .standard)
        }
        updateMoveList()
    }
    
    private func updateMoveList() {
        let database: LichessOpeningQuery.OpeningDatabase = useMastersDatabase ? .masters : .casual
        let params = LichessOpeningQuery(
            openingPath: .moves(history.map({ $0.data.0 })),
            openingDatabase: database)
        Task {
            isLoaded = false
            let rawOpenings = await openingFetcher.fetch(params)?.moves ?? []
            openings = rawOpenings.map({ WrappedStats(data: $0) })
            isLoaded = true
        }
    }

    private func setState(gameState: WrappedGameState) {
        let pastStop = history.first(where: { $0.id == gameState.id })
        let futureStop = future.first(where: { $0.id == gameState.id })
        if let snapshot = pastStop {
            while let shiftedElement = history.popLast() {
                if shiftedElement.id == snapshot.id {
                    history.append(shiftedElement)
                    break
                }
                future.append(shiftedElement)
            }
        } else if let snapshot = futureStop {
             while let shiftedElement = future.popLast() {
                history.append(shiftedElement)
                if shiftedElement.id == snapshot.id {
                    break
                }
            }
        } else {
            return
        }
        updateMoveList()
        boardView.setState(gameState.data.1)
    }
}

#Preview {
    OpeningExplorerView()
}
