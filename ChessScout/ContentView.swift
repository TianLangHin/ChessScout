//
//  ContentView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 16/8/2025.
//

import ChessKit
import SwiftUI

/// The main view and title page of the ChessScout app.
struct ContentView: View {
    // This type alias is made for convenient use within the View body.
    typealias GameState = GameRouterViewModel.Indicator

    // This is created to enable programmatic navigation when the user chooses
    // to play the opening revision game.
    @State var gameRouter = GameRouterViewModel()

    // Since some views need to be loaded into memory and persisted in between
    // Views, the `openingLines` ViewModel is initialised once here
    // and reused when passed between Views as an EnvironmentObject.
    @ObservedObject var openingLines = OpeningLinesViewModel()

    // The favourite opening list of the user is persistent throughout the
    // context of the app, therefore this also only needs to be instantiated
    // once and passed to the rest of the views as an EnvironmentObject.
    @ObservedObject var favouriteOpenings = FavouriteOpeningsViewModel()

    var body: some View {
        // The entire app will either use a NavigationLink for intuitive movement
        // or a NavigationStack for programmatic navigation between Views.
        // This is all nested inside a larger NavigationStack to ensure
        // all transitions work harmoniously within the app.
        NavigationStack {
            VStack(spacing: 0) {
                // App Title
                Text("ChessScout")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                // App Icon.
                Image("wr")
                // Main choice of functionalities.
                VStack(alignment: .center) {
                    // First functionality: Opening Explorer.
                    // Here, the user can explore openings at their own pace
                    // with the assistance of Lichess statistics.
                    NavigationLink("Opening Explorer") {
                        OpeningExplorerView()
                            .navigationTitle("Opening Explorer")
                    }
                    .buttonStyle(.borderedProminent)

                    // Second functionality: Opening Revision Game.
                    // Here, the user will be prompted with random openings
                    // and tested to see if they remember the final move correctly.
                    NavigationStack(path: $gameRouter.gameStack) {
                        Button {
                            gameRouter.gameStack.append(.select)
                        } label: {
                            Text("Start Game")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .navigationDestination(for: GameState.self) { indicator in
                        // This game requires programmatic navigation
                        // which is determined by the `gameRouter`
                        // initialised at the beginning of the View's creation.
                        // Both ObservedObjects are passed as EnvironmentObjects
                        // so that the `GameState` does not have to do all the
                        // heavy lifting.
                        gameRouter
                            .getView(indicator, path: $gameRouter.gameStack)
                            .environmentObject(openingLines)
                            .environmentObject(favouriteOpenings)
                            .navigationTitle("Opening Revision Game")
                    }

                    // Third functionality: Adding Favourite Openings.
                    // This works together with the opening revision game.
                    // Users can customise which openings they like the most
                    // and can choose to just revise those.
                    // As a result, only `favouriteOpenings` is needed
                    // to be passed as an EnvironmentObject.
                    NavigationLink("Favourite Openings") {
                        FavouriteOpeningsView()
                            .environmentObject(favouriteOpenings)
                            .navigationTitle("Favourite Openings")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
    }
}

#Preview {
    ContentView()
}
