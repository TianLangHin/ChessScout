//
//  FavouriteOpeningsView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 29/8/2025.
//

import SwiftUI

/// This View displays all the openings that have currently been selected as a favourite by the user.
/// It allows addition and deletion of these lists,
/// which can be used as a revision source instead of entire opening books.
struct FavouriteOpeningsView: View {
    // The list of favourite openings is a global context for the user in the platform.
    // As a result, `favouriteOpenings` is passed as an EnvironmentObject.
    @EnvironmentObject var favouriteOpenings: FavouriteOpeningsViewModel

    var body: some View {
        VStack {
            List {
                if favouriteOpenings.openings.isEmpty {
                    // Placeholder text rather than just an empty list,
                    // to indicate to the user that the list is empty (rather than seemingly loading).
                    Text("No favourite openings yet!")
                } else {
                    // Besides listing the openings, we also enable the deletion of favourite openings in this view.
                    ForEach(favouriteOpenings.openings) { idOpening in
                        // Each opening in the list is wrapped in an `IdWrapper` to work seamlessly with `ForEach`.
                        // Hence, the inner data is extracted in the following line.
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
            // To select from the vast list of openings, a separate view is opened for the user.
            NavigationLink("Add Opening") {
                OpeningSelectorView()
                    .environmentObject(favouriteOpenings)
            }
        }
        .padding()
    }
}
