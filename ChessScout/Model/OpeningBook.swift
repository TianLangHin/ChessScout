//
//  OpeningBook.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 3/9/2025.
//

enum OpeningBook: String {
    case a, b, c, d, e

    static func from(number: Int) -> Self? {
        switch number {
        case 0:
            return .a
        case 1:
            return .b
        case 2:
            return .c
        case 3:
            return .d
        case 4:
            return .e
        default:
            return nil
        }
    }
}
