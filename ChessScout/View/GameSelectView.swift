//
//  GameSelectView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

/// This View is shown at the start of every opening revision game,
/// so that the player gets to customise their experience each time.
/// The player can choose to either revise using certain ECO opening books
/// or to revise using only the list of favourite openings.
/// Additionally, the user can select the number of rounds to be played,
/// which is capped at 10 for a realistically achievable game.
struct GameSelectView: View {
    // The `openingLines` ViewModel is provided as an EnvironmentObject
    // to load the openings into memory before the game is started.
    @EnvironmentObject var openingLines: OpeningLinesViewModel
    // The user's favourite openings list is provided in case the user
    // chooses to revise openings from the list.
    @EnvironmentObject var favourites: FavouriteOpeningsViewModel

    // Since this view will have to programmatically navigate to the GameView,
    // it also needs a Binding to the path that governs the navigation stack.
    @Binding var path: [GameRouterViewModel.Indicator]

    // These govern the choice made by the user on whether the revision game
    // will prompt openings only with the user's favourite openings,
    // or if the game will draw from any of the 5 ECO opening books.
    @State var usingFavourites = false
    @State var selection = [false, false, false, false, false]

    // This ensures that the game will only start when a valid selection is made,
    // since there are some selection combinations that result in an empty
    // opening list from which the same draws its prompts.
    @State var disableProgression = false

    // An error message may appear sometimes,
    // but since conditional rendering will cause other UI elements to shift,
    // it is instead rendered transparent when it should not be displayed.
    @State var errorMessageOpacity = 0.0

    // The default number of rounds in the game to be started.
    @State var numberOfRounds = 1.0

    var body: some View {
        VStack {
            Text("Choose your game mode:")
                .font(.title)
            VStack {
                // This button toggles whether the game is to be drawn from the
                // user's favourite openings list or whether ECO books are used.
                // By default, ECO opening books will be used.
                Button {
                    usingFavourites.toggle()
                } label: {
                    // Since it is not intuitive which option is being selected
                    // when using a switch UI element (since neither is "truthy"),
                    // the text of the button instead reflects the current choice.
                    if usingFavourites {
                        Text("Revise from Favourites")
                    } else {
                        Text("Revise from Opening Books")
                    }
                }
                .padding()
                .buttonStyle(.bordered)
                // This UI element acts as a multi-selector, which is not
                // readily available in SwiftUI in a standardised manner.
                // Therefore, each ECO book option is a checkmarked button
                // that separately updates the corresponding index of the
                // `selection` state variable.
                // This should not appear if `usingFavourites` is true,
                // but this is governed via opacity so that
                // other UI elements do not shift.
                VStack {
                    Text("Select ECO Opening Books to train on:")
                        .fontWeight(.bold)
                    HStack {
                        // Each of these is a smaller nested View that directly
                        // manipulates the state of this GameSelectView.
                        radioButton(index: 0, text: "A")
                        radioButton(index: 1, text: "B")
                        radioButton(index: 2, text: "C")
                        radioButton(index: 3, text: "D")
                        radioButton(index: 4, text: "E")
                    }
                }
                .opacity(usingFavourites ? 0.0 : 1.0)
            }
            .padding()
            // This slider lets the user choose how many rounds the game should
            // last, and caps this at 10 rounds to ensure a reasonable selection.
            VStack {
                Text("Number of Rounds: \(Int(numberOfRounds))")
                Slider(value: $numberOfRounds, in: 1...10, step: 1) {
                } minimumValueLabel: {
                    Text("1")
                } maximumValueLabel: {
                    Text("10")
                }
            }
            .padding()
            // The final "Start Game!" button will move the user to the GameView
            // if a valid selection has been made with the above UI elements.
            Button {
                // It is a valid selection if either:
                // - Using favourites and the favourites list is not empty, or
                // - Using opening books and at least one book has been selected.
                let canUseFavourites = favourites.openings.count != 0
                let canUseBooks = !selection.allSatisfy({ !$0 })
                // The above is summarised using Boolean laws in the if-statement.
                if ((usingFavourites && canUseFavourites) || canUseBooks) {
                    // To ensure the button does not get pressed multiple times
                    // and causes problems to the stack navigation,
                    // due to the latency of the API calls needed upon load.
                    disableProgression = true
                    Task {
                        if usingFavourites {
                            // If the game uses favourite openings,
                            // these are loaded into the `openingLines` ViewModel
                            // for the GameView to extract as an EnvironmentObject.
                            let openings = favourites.openings.map({ $0.data })
                            await openingLines.loadOpenings(favourites: openings)
                        } else {
                            // If the game uses ECO opening books, use the
                            // `selection` array to determine which ones to load.
                            var bookList: [OpeningBook] = []
                            for i in 0..<selection.count {
                                let book = OpeningBook.from(number: i)
                                if selection[i] && book != nil {
                                    bookList.append(book!)
                                }
                            }
                            // Finally, load them into the `openingLines` ViewModel.
                            await openingLines.loadOpenings(ecos: bookList)
                        }
                        // After the openings have finished loading from the
                        // external source, only then does the view programmatically
                        // navigate to the GameView.
                        // The information that needs to be passed directly
                        // via the path element is the number of rounds to play.
                        path.append(.game(Int(numberOfRounds)))
                    }
                } else {
                    // Only display possible progression indicator when the
                    // "Start Game!" button is pressed and fails for the first time.
                    errorMessageOpacity = 1.0
                }
            } label: {
                Text("Start Game!")
            }
            .disabled(disableProgression)
            // The error message is a View displaying some text
            // with different colours depending on the content,
            // hence is abstracted as a function within this View.
            errorMessage()
                .padding()
                .opacity(errorMessageOpacity)
        }
        .padding()
    }

    /// Represents a single selection indicator of an ECO opening book
    /// from which openings can be drawn during the game.
    /// Each one will toggle a certain index of the `selection` array,
    /// and have a specific piece of text above it representing
    /// its corresponding opening book.
    private func radioButton(index: Int, text: String) -> some View {
        VStack {
            Text("\(text)")
            Button {
                if !usingFavourites {
                    selection[index].toggle()
                }
            } label: {
                // To create the effect of clicking the button,
                // the checkmark image is used as the label of the button.
                let suffix = selection[index] ? ".fill" : ""
                Image(systemName: "checkmark.square" + suffix)
            }
        }
    }

    /// The error message indicating whether the user can proceed to the game
    /// is always a Text element, but may have different foreground styles.
    /// This causes different types to potentially appear,
    /// and thus requires a ViewBuilder attribute for convenient syntax.
    /// Its content depends on whether the selections in the main view above
    /// allow the game to be played in a valid manner or not.
    @ViewBuilder
    private func errorMessage() -> some View {
        let canUseFavourites = favourites.openings.count != 0
        let canUseBooks = !selection.allSatisfy({ !$0 })
        if usingFavourites {
            if canUseFavourites {
                Text("You may proceed!")
                    .foregroundStyle(.green)
            } else {
                Text("Your favourites list is empty!")
                    .foregroundStyle(.red)
            }
        } else {
            if canUseBooks {
                Text("You may proceed!")
                    .foregroundStyle(.green)
            } else {
                Text("You need to select at least 1 book!")
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    GameSelectView(path: .constant([]))
        .environmentObject(OpeningLinesViewModel())
        .environmentObject(FavouriteOpeningsViewModel())
}
