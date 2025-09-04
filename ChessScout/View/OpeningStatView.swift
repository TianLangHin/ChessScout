//
//  OpeningStatView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 26/8/2025.
//

import SwiftUI

/// This View is not used on its own,
/// but rather as a component in the `OpeningExplorerView`.
/// It displays a single move in an opening with its Lichess statistics
/// to provide a visual display of its historical viability.
struct OpeningStatView: View {
    // The opening data must be supplied to this View to visualise it.
    @State var openingStat: LichessOpeningData.MoveStats

    // The `OpeningStatViewModel` handles the logic of ensuring
    // the numbers shown are intuitive.
    @State var viewModel = OpeningStatViewModel()

    var body: some View {
        // The ViewModel returns the numbers to be displayed,
        // which represent the number of white wins, draws, and black wins
        // of that move in this given position.
        let (white, draws, black) = viewModel.intuitivePercentage(openingStat)
        // This view uses two GeometryReaders: an outer one to provide a
        // proportion by which to display the inner rectangle that shows stats.
        GeometryReader { outerProxy in
            HStack {
                Text("\(openingStat.san)")
                    .frame(alignment: .center)
                Spacer()
                // Each of the stats are shown in a rectangle that is
                // directly proportional to its relative occurrence percentage.
                GeometryReader { innerProxy in
                    HStack(spacing: 0) {
                        resultRectangle(bg: .white, fg: .black, ratio: white, geometry: innerProxy)
                        resultRectangle(bg: .gray, fg: .black, ratio: draws, geometry: innerProxy)
                        resultRectangle(bg: .black, fg: .white, ratio: black, geometry: innerProxy)
                    }
                    .border(.black)
                }
                .frame(width: 0.8 * outerProxy.size.width)
            }
        }
    }

    /// Each rectangle within the stats data on the right takes up
    /// the portion of width equal to its percentage.
    /// If the rectangle area is too small, the number is not displayed
    /// since it will clutter the UI with no additional benefit.
    private func resultRectangle(bg: Color, fg: Color, ratio: Int, geometry: GeometryProxy) -> some View {
        ZStack {
            let width = Int(geometry.size.width)
            let height = geometry.size.height
            Rectangle()
                .fill(bg)
                .frame(width: CGFloat(width * ratio / 100), height: height)
            // Conditional rendering is used in case the rectangle is too narrow.
            if ratio > viewModel.visibleThreshold {
                Text("\(ratio)%")
                    .foregroundStyle(fg)
                    .font(.footnote)
            }
        }
    }
}

#Preview {
    let opening = LichessOpeningData.MoveStats(
        white: 10, draws: 20, black: 9, san: "e4", averageRating: 2411)
    List {
        OpeningStatView(openingStat: opening)
    }
}
