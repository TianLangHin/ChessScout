//
//  ContentView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 16/8/2025.
//

import ChessKit
import SwiftUI

struct ContentView: View {

    typealias GameState = GameRouterViewModel.Indicator
    @State var gameRouter = GameRouterViewModel()

    @ObservedObject var openingLines = OpeningLinesViewModel()
    @ObservedObject var favouriteOpenings = FavouriteOpeningsViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text("ChessScout")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Image("wr")
                VStack(alignment: .center) {
                    NavigationLink("Opening Explorer") {
                        OpeningExplorerView()
                            .navigationTitle("Opening Explorer")
                    }
                    .buttonStyle(.borderedProminent)
                    NavigationStack(path: $gameRouter.gameStack) {
                        Button {
                            gameRouter.gameStack.append(.select)
                        } label: {
                            Text("Start Game")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .navigationDestination(for: GameState.self) { indicator in
                        gameRouter
                            .getView(indicator, path: $gameRouter.gameStack)
                            .environmentObject(openingLines)
                            .environmentObject(favouriteOpenings)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
