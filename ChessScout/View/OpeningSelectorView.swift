//
//  OpeningSelectorView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 31/8/2025.
//

import SwiftUI

/// The View that is used as a utility to add select an opening to add to the user's list
/// of favourite openings. A separate view like this is used since the options to choose from
/// is very large, and should not be shown in conjunction with other information (such as another list).
/// It supports the selection by tapping of a single opening, as well as searching to find the right one.
struct OpeningSelectorView: View {
    // This view allows the user to select a particular opening and add it to their favourites,
    // meaning that it must have access to the global `favouriteOpenings` EnvironmentObject.
    @EnvironmentObject var favouriteOpenings: FavouriteOpeningsViewModel

    // Additionally, since it needs to have a list of all possible openings to choose from,
    // it needs its own copy of an OpeningLinesViewModel instance.
    @ObservedObject var openingLines = OpeningLinesViewModel()

    // This View does not use programmatic navigation, but will be part of a NavigationStack.
    // Since it must go back to the previous view, the `dismiss` environment function is used.
    @Environment(\.dismiss) var dismiss

    // The internal state that carries the search string for the user to find an opening.
    @State var query = ""

    var body: some View {
        VStack {
            // Opening names can be strange in spelling,
            // so any autocorrection or autocapitalisation is disabled.
            // This works well with the backend filtering logic ignoring cases as well.
            TextField("Search openings here", text: $query)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
            // The ViewModel provides the filtering functionality (which allows queries to match as a subsequence).
            List(openingLines.filterOn(query: query), id: \.self) { opening in
                HStack {
                    Text("\(opening.eco)")
                        .fontWeight(.bold)
                    VStack(alignment: .leading) {
                        Text("\(opening.line)")
                        Text("\(opening.moves.joined(separator: " "))")
                    }
                }
                .onTapGesture {
                    // Each element is not a button, but detects a tap gesture instead.
                    // This is to maintain simplistic formatting since it is obvious they are selectable.
                    favouriteOpenings.addOpening(opening: opening)
                    dismiss()
                }
            }
        }
        .onAppear {
            // When this view is loaded, all openings must be available.
            // Hence, the very first process it carries out is to load all 5 ECO opening books.
            Task {
                await openingLines.loadOpenings(ecos: [.a, .b, .c, .d, .e])
            }
        }
    }
}
