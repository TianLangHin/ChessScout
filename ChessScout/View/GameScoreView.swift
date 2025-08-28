//
//  GameScoreView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

struct GameScoreView: View {

    @Binding var path: [GameRouterViewModel.Indicator]

    var body: some View {
        VStack {
            Button {
                path.removeAll()
            } label: {
                Text("Go all the way back")
            }
        }
    }
}
