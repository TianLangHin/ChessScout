//
//  OpeningStatView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 26/8/2025.
//

import SwiftUI

struct OpeningStatView: View {
    @State var openingStat: LichessOpeningData.MoveStats

    @State var viewModel = OpeningStatViewModel()

    var body: some View {
        let (white, draws, black) = viewModel.intuitivePercentage(openingStat)
        GeometryReader { outerProxy in
            HStack {
                Text("\(openingStat.san)")
                    .frame(alignment: .center)
                Spacer()
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

    func resultRectangle(bg: Color, fg: Color, ratio: Int, geometry: GeometryProxy) -> some View {
        ZStack {
            let width = Int(geometry.size.width)
            let height = geometry.size.height
            Rectangle()
                .fill(bg)
                .frame(width: CGFloat(width * ratio / 100), height: height)
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
