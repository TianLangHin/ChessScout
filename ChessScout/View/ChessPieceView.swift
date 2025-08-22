//
//  ChessPieceView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 22/8/2025.
//

import SwiftUI

struct ChessPieceView: View {
    @Binding var chessPiece: ChessPiece

    let imageFetcher = PieceAssetFetcher()

    var body: some View {
        AsyncImage(url: imageFetcher.fetch(chessPiece.piece)) { result in
            result.image?.resizable().scaledToFill()
        }
    }
}
