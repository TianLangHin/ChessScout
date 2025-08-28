//
//  GameSelectView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

struct GameSelectView: View {

    @Binding var path: [GameRouterViewModel.Indicator]

    var body: some View {
        VStack {
            Spacer()
            Button {
                path.append(.game)
            } label: {
                Text("Move to Game")
            }
            Spacer()
        }
        .padding()
    }
}
