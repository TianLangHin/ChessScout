//
//  ChessboardView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 22/8/2025.
//

import ChessKit
import SwiftUI

/// The `ChessboardView` struct displays a particular chess position,
/// with piece animations when moves are made.
/// It is then also extended to conform to the `Navigable` protocol
/// to allow other views to contain this one without having to
/// copy across its state logic.
struct ChessboardView: View {
    // Firstly, the colours of the chessboard are defined here.
    // White and brown are chosen as a common scheme used for chessboards.
    let light = Color.white
    let dark = Color.brown

    // The state management of a chessboard is abstracted into a ViewModel.
    @State var board = ChessboardViewModel()

    var body: some View {
        // To ensure the chessboard shows as a square and uses the maximum space
        // and to enable fine control over animations and movements of pieces
        // within the space, a `GeometryReader` is used to set view locations in the UI.
        GeometryReader { geometry in
            // The `ZStack` below is set to use up as much width as possible.
            ZStack {
                // Since the board is a square, the maximum side length is
                // the minimum of the width and height of the provided space.
                let sideLength = min(geometry.size.width, geometry.size.height)
                // The board has 64 squares from dividing each side by 8.
                let step = sideLength / 8
                // First, the square pattern underneath is drawn.
                boardLayer(squareSize: step)
                // Each piece is placed at an offset measured from the centre.
                // The centre of the A1 square is 3.5 steps away from this point.
                let offset = -3.5 * step
                ForEach($board.pieceList) { $chessPiece in
                    // The `offset` calculated earlier sets the start of each
                    // piece location calculation at the A1 square.
                    // Given a little endian `squareNumber` convention, the number
                    // of steps upwards/leftwards to place the piece is found.
                    let stepsX = CGFloat(chessPiece.squareNumber % 8)
                    let stepsY = CGFloat(7 - chessPiece.squareNumber / 8)
                    let xCoord = offset + stepsX * step
                    let yCoord = offset + stepsY * step
                    // The piece is finally placed at that spot within the board.
                    ChessPieceView(chessPiece: $chessPiece)
                        .frame(width: step, height: step)
                        .offset(x: xCoord, y: yCoord)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func boardLayer(squareSize: CGFloat) -> some View {
        VStack(spacing: 0) {
            ForEach((0..<8).reversed(), id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<8, id: \.self) { column in
                        // Whether the square is light or dark
                        // depends on the Manhattan distance from A1.
                        let colour = (row + column) % 2 == 0 ? dark : light
                        // Each square is thus a `Rectangle` with that colour.
                        Rectangle()
                            .fill(colour)
                            .frame(width: squareSize, height: squareSize)
                    }
                }
            }
        }
            .border(Color.black, width: 2)
    }
}

/// This extension makes it so that `ChessboardView` can be stored
/// as a child View in other pages and be directly manipulatable
/// without needing to manually deal with its internal ViewModel every time.
extension ChessboardView: Navigable {
    /// The types through which its state and transitions are represented
    /// are `Position` and `Move` which are both given by `ChessKit`
    /// with chess-specific logic built-in.
    typealias GameState = Position
    typealias Transition = Move

    // The internal chessboard position represents the view's state.
    func getState() -> GameState {
        return self.board.position
    }

    // Both `setState` and `resetState` are done by setting the internal
    // ViewModel's position. The latter is just a special case where it gets
    // set to the starting position.
    mutating func setState(_ state: GameState) {
        self.board.setPosition(position: state)
    }

    mutating func resetState() {
        self.board.setPosition(position: .standard)
    }

    // This function is responsible for animating moves being made,
    // and justifies the use of this protocol.
    // This way, the animation only needs to be defined in one place
    // for the entire ChessboardView to be used consistently across pages.
    @discardableResult
    mutating func makeTransition(_ move: Transition) -> Bool {
        withAnimation(.linear(duration: 0.25)) {
            return self.board.makeMove(move: move)
        }
    }
}

#Preview {
    ChessboardView()
}
