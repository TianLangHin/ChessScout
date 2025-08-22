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
            ZStack {
                let step = min(geometry.size.width, geometry.size.height) / 8
                let offset = -3*step - min(geometry.size.width, geometry.size.height) / 16
                boardLayer(squareSize: step)
                ForEach($board.model.pieceList) { $chessPiece in
                    let stepsX = CGFloat(chessPiece.piece.square.rawValue % 8)
                    let stepsY = CGFloat(7 - chessPiece.piece.square.rawValue / 8)
                    ChessPieceView(chessPiece: $chessPiece)
                        .frame(width: step, height: step)
                        .offset(x: offset + stepsX * step, y: offset + stepsY * step)
                }
            }
        }
        .padding()
    }

    private func boardLayer(squareSize: CGFloat) -> some View {
        VStack(spacing: 0) {
            ForEach((0..<8).reversed(), id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<8, id: \.self) { column in
                        Rectangle()
                            .fill((row + column) % 2 == 0 ? darkSquare: lightSquare)
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
        return self.board.model.board.position
    }
    
    mutating func setState(_ state: GameState) {
        self.board.setPosition(position: state)
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
