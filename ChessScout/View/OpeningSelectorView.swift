//
//  OpeningSelectorView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 31/8/2025.
//

import SwiftUI

struct OpeningSelectorView: View {

    @EnvironmentObject var favouriteOpenings: FavouriteOpeningsViewModel
    @EnvironmentObject var openingLines: OpeningLinesViewModel

    @Environment(\.dismiss) var dismiss

    @State var query = ""

    var body: some View {
        VStack {
            TextField("Search openings here", text: $query)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .padding()
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
                    favouriteOpenings.addOpening(opening: opening)
                    dismiss()
                }
            }
            .onAppear {
                Task {
                    await openingLines.loadOpenings(ecos: [.a, .b, .c, .d, .e])
                }
            }
        }
    }
}
