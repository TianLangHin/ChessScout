//
//  GameSelectView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

struct GameSelectView: View {
    @EnvironmentObject var openingLines: OpeningLinesViewModel
    @EnvironmentObject var favouriteOpenings: FavouriteOpeningsViewModel

    @Binding var path: [GameRouterViewModel.Indicator]
    @State var openings: [NamedOpeningLine] = []
    
    @State var usingFavourites = false
    @State var selection = [false, false, false, false, false]

    @State var disableProgression = false

    @State var numberOfRounds = 1.0

    var body: some View {
        VStack {
            Text("Choose your game mode:")
            Toggle(isOn: $usingFavourites) {
                Text(usingFavourites ? "Revise From Favourites" : "Revise From Opening Books")
            }
            .toggleStyle(.button)
            HStack {
                radioButton(index: 0, text: "A")
                radioButton(index: 1, text: "B")
                radioButton(index: 2, text: "C")
                radioButton(index: 3, text: "D")
                radioButton(index: 4, text: "E")
            }
            .opacity(usingFavourites ? 0.0 : 1.0)
            Text("Number of Rounds: \(Int(numberOfRounds))")
                .padding()
            Slider(value: $numberOfRounds, in: 1...10, step: 1)
                .padding()
            Button {
                if usingFavourites || !selection.allSatisfy({ !$0 }) {
                    disableProgression = true
                    Task {
                        if usingFavourites {
                            let openings = favouriteOpenings.openings.map({ $0.data })
                            await openingLines.loadOpenings(favourites: openings)
                        } else {
                            var bookList: [OpeningBook] = []
                            for i in 0..<selection.count {
                                let book = OpeningBook.from(number: i)
                                if selection[i] && book != nil {
                                    bookList.append(book!)
                                }
                            }
                            await openingLines.loadOpenings(ecos: bookList)
                        }
                        path.append(.game(Int(numberOfRounds)))
                    }
                }
            } label: {
                Text("Start Game!")
            }
            .disabled(disableProgression)
        }
        .padding()
    }

    func radioButton(index: Int, text: String) -> some View {
        VStack {
            Text("\(text)")
            Button {
                if !usingFavourites {
                    selection[index].toggle()
                }
            } label: {
                Image(systemName: "checkmark.square" + (selection[index] ? ".fill" : ""))
            }
        }
    }
}
