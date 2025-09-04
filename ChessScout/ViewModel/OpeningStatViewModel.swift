//
//  OpeningStatViewModel.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 27/8/2025.
//

import SwiftUI

/// This ViewModel handles the logic of making sure that an opening statistic
/// fetched from the Lichess API gives total win-rate percentages that add up to 100%.
/// This makes it intuitive for users and also aligns all the rectangles in the UI.
@Observable
class OpeningStatViewModel {
    // Type alias is made only for convenience here.
    typealias OpeningStat = LichessOpeningData.MoveStats

    // The threshold below which the percentage is deemed too wide to fit in the rectangle.
    let visibleThreshold = 8

    // The main function through which the percentages are managed.
    func intuitivePercentage(_ openingStat: OpeningStat) -> (Int, Int, Int) {
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
