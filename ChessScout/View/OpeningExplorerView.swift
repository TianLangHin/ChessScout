//
//  OpeningExplorerView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 24/8/2025.
//

import ChessKit
import SwiftUI

/// This View provides one of the main functionalities of the app,
/// which is exploring openings with statistics pulled from the Lichess database
/// to guide users on which moves would be potentially the best one to play.
struct OpeningExplorerView: View {
    // The following type aliases make some declarations within this View
    // more convenient, particularly when `List` and `ForEach` are used on
    // items that are not naturally Identifiable or conveniently Hashable.
    typealias GameState = (Move, Position)
    typealias WrappedGameState = IdWrapper<GameState>
    typealias WrappedStats = IdWrapper<LichessOpeningData.MoveStats>

    // Firstly, the navigation of the board state is controlled
    // by the `openingExplorer` ViewModel,
    // so that the user can navigate back and forth
    // within a consistent opening line history, potentially changing
    // the explored line if need be.
    @State var openingExplorer = OpeningExplorerViewModel()

    // The list of moves being displayed is kept track of in the View.
    @State var moves: [WrappedStats] = []

    // This View also requires the visualisation of moves on a chessboard.
    // Hence, an instance of a `ChessboardView` is stored as a component.
    @State var boardView = ChessboardView()

    // Since the loading of opening stats requires an API call which may
    // take a substantial amount of time, this indicator allows the UI
    // to display a loading message when this process is still going.
    @State var isLoaded = false

    var body: some View {
        VStack {
            // The chessboard is shown at the top of the view,
            // since it is the focus of the user.
            boardView

            // Directly below it is the move sequence and history
            // that is currently being explored.
            HStack {
                // On the left, the user can toggle which Lichess database to use.
                Button {
                    openingExplorer.useMastersDatabase.toggle()
                } label: {
                    // The text content reflects the current choice since
                    // it neither value is a "truthy" value that can be
                    // intuitively used with a switch element.
                    if openingExplorer.useMastersDatabase {
                        Text("Masters")
                    } else {
                        Text("Casual")
                    }
                }
                .buttonStyle(.bordered)
                .frame(width: 90)

                // Next to it, the move sequence is displayed.
                historyLayer()
            }
            .padding()

            if !isLoaded {
                // This provides an indicator to the user that
                // the data is still in the process of being fetched,
                // so that they do not mistakenly believe the app has malfunctioned.
                List {
                    Text("Loading Opening Data...")
                }
            } else if moves.isEmpty {
                // Rather than just having a List element that contains nothing,
                // if the opening database does not contain the explored line,
                // this is made explicitly clear.
                // This way, the user will not think the UI has malfunctioned.
                List {
                    Text("This line was not found in the database.")
                }
            } else {
                List {
                    // A section is used to show the user what the
                    // components of each row are describing,
                    // making their usage more intuitive and guided.
                    Section {
                        ForEach(moves) { opening in
                            // To make these rows displayable in a ForEach,
                            // they are wrapped with an `IdWrapper`
                            // to make them Identifiable. As a result, the inner
                            // `data` property has to be fetched before being
                            // used to instantiate the `OpeningStatView`.
                            let moveStats = opening.data
                            Button {
                                makeMove(moveSan: moveStats.san)
                            } label: {
                                // Each row is explicitly set to use the entire
                                // width, since it is a GeometryWrapper.
                                OpeningStatView(openingStat: moveStats)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    } header: {
                        // These provide the descriptions of the contents of
                        // each row in the list being shown under the chessboard.
                        HStack {
                            Text("Move")
                            Spacer()
                            Text("White win / Draw / Black win")
                        }
                    }
                }
                .listStyle(.grouped)
            }

            // The final UI element is at the bottom, providing intuitive
            // back and forth nagivation of the move sequence being explored.
            HStack {
                // Padding is added to both images so that the buttons are spaced
                // reasonably without using a Spacer to make it impractical.
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
            // This is required to refresh the ViewModel state every time the
            // View loads, since it is a class and otherwise preserves the state
            // in some situations.
            boardView.resetState()
            openingExplorer.reset()
            updateMoveList()
        })
        .onChange(of: openingExplorer.useMastersDatabase, {
            // In addition to making a move or navigating within the sequence,
            // the new opening stats need to be fetched when the database setting
            // is changed.
            updateMoveList()
        })
    }

    /// This pulls out the component of the View that shows the opening move
    /// sequence that is currently being explored, so that the main body
    /// of the `OpeningExplorerView` does not get too cluttered.
    private func historyLayer() -> some View {
        // Since the sequence of moves is displayed horizontally,
        // and can get very easily get longer than displayable on the screen,
        // it is put in a ScrollView that can scroll horizontally
        // and automatically scroll to the move indicating the current position.
        ScrollViewReader { scrollView in
            ScrollView(.horizontal, showsIndicators: false) {
                // Although it is displayed as a single row,
                // the navigation is expressed through two lists
                // in the `openingExplorer` ViewModel: `history` and `future`.
                // The last element of the `history` array is always the current
                // move being explored. If it is empty, then the board is at the
                // starting position.
                //
                // Additionally, each item in this row is interactive,
                // such that if it is clicked on, the board will navigate
                // directly to the game state that it represents.
                HStack {
                    // Display the moves before the current one.
                    ForEach(openingExplorer.history.dropLast()) { gameState in
                        Button {
                            setState(gameState: gameState)
                        } label: {
                            Text("\(gameState.data.0)")
                                .foregroundStyle(.red)
                        }
                    }
                    // If there is a "current move"
                    // (i.e., not currently viewing the start position),
                    // then display the item with the special ID of `0`
                    // so that the ScrollViewReader can automatically scroll to it.
                    if let currentState = openingExplorer.history.last {
                        Button {
                            setState(gameState: currentState)
                        } label: {
                            Text("\(currentState.data.0)")
                                .foregroundStyle(.green)
                        }
                        .id(0)
                    }
                    // Display the moves after the current one.
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
                // This ensures the current move being shown on the board
                // is always visible to the user, ensuring a smooth user experience.
                // The `0` ID is always assigned to the current move item.
                scrollView.scrollTo(0)
            }
        }
    }

    /// This function handles the logic where any move is made,
    /// triggering the update of the UI, move list, and ViewModel.
    /// It can be set to clear the `future` array which is needed when
    /// a user navigates backwards and chooses a different opening line
    /// from previously.
    private func makeMove(moveSan: String, clearFuture clear: Bool = true) {
        // This will only trigger a UI update if the move is valid
        // in the current state, to ensure no asynchronous timing mismatches
        // cause the entire UI to show an erroneous state.
        if let move = Move(san: moveSan, position: boardView.getState()) {
            if boardView.makeTransition(move) {
                openingExplorer.makeMove(
                    move: move, newState: boardView.getState(), clearFuture: clear)
                // If this was successful, the moves list needs to be updated.
                updateMoveList()
            }
        }
    }

    /// The function called by the right chevron button at the bottom.
    /// Moves forward within the opening sequence, but does nothing if there
    /// are no moves in the future.
    private func moveForward() {
        if let futureState = openingExplorer.future.popLast() {
            makeMove(moveSan: futureState.data.0.san, clearFuture: false)
        }
    }

    /// The function called by the left chevron button at the bottom.
    /// Moves backward within the opening sequence, but does nothing if there
    /// are no moves in the past (i.e., currently at starting position).
    private func moveBackward() {
        if let undoneState = openingExplorer.history.popLast() {
            openingExplorer.future.append(undoneState)
            boardView.setState(openingExplorer.history.last?.data.1 ?? .standard)
        }
        updateMoveList()
    }

    /// The function called by each of the elements in the move sequence
    /// shown in the middle of the View.
    private func setState(gameState: WrappedGameState) {
        // The ViewModel is called such that its internal state is
        // set to the game position just after the selected move
        // in the move sequence is made.
        let success = openingExplorer.setState(gameState: gameState)
        // Only update the UI if the transition was valid,
        // to ensure desynchronisation does not invalidate the UI.
        if success {
            updateMoveList()
            boardView.setState(gameState.data.1)
        }
    }

    /// The utility function used to refresh the move list
    /// displayed in the bottom half of the UI.
    /// Fetches from the Lichess database using the attached ViewModel.
    private func updateMoveList() {
        Task {
            // The `isLoaded` variable is set during the asynchronous task
            // to ensure the user is not able to send multiple clashing requests.
            isLoaded = false
            moves = await openingExplorer.fetch()
            isLoaded = true
        }
    }
}

#Preview {
    OpeningExplorerView()
}
