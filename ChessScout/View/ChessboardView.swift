//
//  ChessboardView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 22/8/2025.
//

import ChessKit
import SwiftUI

struct ChessboardView: View {

    let lightSquare = Color.white
    let darkSquare = Color.brown

    @State var board = ChessboardViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    let sideLength = min(geometry.size.width, geometry.size.height)
                    let step = sideLength / 8
                    let offset = -(3 * step + sideLength / 16)
                    boardLayer(squareSize: step)
                    ForEach($board.pieceList) { $chessPiece in
                        let stepsX = CGFloat(chessPiece.squareNumber % 8)
                        let stepsY = CGFloat(7 - chessPiece.squareNumber / 8)
                        ChessPieceView(chessPiece: $chessPiece)
                            .frame(width: step, height: step)
                            .offset(x: offset + stepsX * step, y: offset + stepsY * step)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func boardLayer(squareSize: CGFloat) -> some View {
        VStack(spacing: 0) {
            ForEach((0..<8).reversed(), id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<8, id: \.self) { column in
                        Rectangle()
                            .fill((row + column) % 2 == 0 ? darkSquare : lightSquare)
                            .frame(width: squareSize, height: squareSize)
                    }
                }
            }
        }
            .border(Color.black, width: 2)
    }
}

extension ChessboardView: Navigable {
    typealias GameState = Position
    typealias Transition = Move

    func getState() -> GameState {
        return self.board.position
    }

    mutating func setState(_ state: GameState) {
        self.board.setPosition(position: state)
    }

    mutating func resetState() {
        self.board.setPosition(position: .standard)
    }

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
