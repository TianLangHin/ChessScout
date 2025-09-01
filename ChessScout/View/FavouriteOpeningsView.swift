//
//  FavouriteOpeningsView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

struct FavouriteOpeningsView: View {

    @EnvironmentObject var favouriteOpenings: FavouriteOpeningsViewModel
    @EnvironmentObject var openingLines: OpeningLinesViewModel

    @State var name: String = ""

    var body: some View {
        VStack {
            List {
                if favouriteOpenings.openings.isEmpty {
                    Text("No favourite openings yet!")
                } else {
                    ForEach(favouriteOpenings.openings) { idOpening in
                        let opening = idOpening.data
                        HStack {
                            Text("\(opening.eco)")
                                .fontWeight(.bold)
                            VStack(alignment: .leading) {
                                Text("\(opening.line)")
                                Text("\(opening.moves.joined(separator: " "))")
                            }
                        }
                    }
                    .onDelete(perform: favouriteOpenings.removeOpenings)
                }
            }
            NavigationLink("Add Opening") {
                OpeningSelectorView()
                    .environmentObject(favouriteOpenings)
                    .environmentObject(openingLines)
            }
        }
        .padding()
    }
}
