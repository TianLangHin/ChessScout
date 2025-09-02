//
//  OpeningStatViewModel.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 27/8/2025.
//

import SwiftUI

@Observable
class OpeningStatViewModel {
    typealias OpeningStat = LichessOpeningData.MoveStats

    let visibleThreshold = 8
 
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
