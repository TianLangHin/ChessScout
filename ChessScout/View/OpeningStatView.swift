//
//  OpeningStatView.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 26/8/2025.
//

import SwiftUI

struct OpeningStatView: View {
    @State var openingStat: LichessOpeningData.MoveStats

    let visibleThreshold = 8

    var body: some View {
        let (white, draws, black) = intuitivePercentage(openingStat)
        GeometryReader { proxy in
            HStack {
                Text("\(openingStat.san)")
                    .frame(alignment: .center)
                Spacer()
                GeometryReader { geometry in
                    let width = Int(geometry.size.width)
                    let height = geometry.size.height
                    HStack(spacing: 0) {
                        ZStack {
                            Rectangle()
                                .fill(.white)
                                .frame(width: CGFloat(width * white / 100), height: height)
                            if white > visibleThreshold {
                                Text("\(white)%")
                                    .foregroundStyle(.black)
                                    .font(.footnote)
                            }
                        }
                        ZStack {
                            Rectangle()
                                .fill(.gray)
                                .frame(width: CGFloat(width * draws / 100), height: height)
                            if draws > visibleThreshold {
                                Text("\(draws)%")
                                    .foregroundStyle(.black)
                                    .font(.footnote)
                            }
                        }
                        ZStack {
                            Rectangle()
                                .fill(.black)
                                .frame(width: CGFloat(width * black / 100), height: height)
                            if black > visibleThreshold {
                                Text("\(black)%")
                                    .foregroundStyle(.white)
                                    .font(.footnote)
                            }
                        }
                    }
                    .border(.black)
                }
                .frame(width: 0.8 * proxy.size.width)
            }
        }
    }

    func intuitivePercentage(_ openingStat: LichessOpeningData.MoveStats) -> (Int, Int, Int) {
        let white = openingStat.white
        let draws = openingStat.draws
        let black = openingStat.black
        let totalPlays = white + draws + black
        var whiteRatio = 100 * white / totalPlays
        var drawRatio = 100 * draws / totalPlays
        var blackRatio = 100 * black / totalPlays
        let numeratorSum = whiteRatio + drawRatio + blackRatio
        if numeratorSum != 100 {
            let highest = max(whiteRatio, max(drawRatio, blackRatio))
            switch highest {
            case whiteRatio:
                whiteRatio += 100 - numeratorSum
            case drawRatio:
                drawRatio += 100 - numeratorSum
            case blackRatio:
                blackRatio += 100 - numeratorSum
            default:
                break
            }
        }
        return (whiteRatio, drawRatio, blackRatio)
    }
}

#Preview {
    let opening = LichessOpeningData.MoveStats(
        white: 10, draws: 20, black: 9, san: "e4", averageRating: 2411)
    List {
        OpeningStatView(openingStat: opening)
    }
}
