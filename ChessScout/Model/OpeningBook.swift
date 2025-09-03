//
//  OpeningBook.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 3/9/2025.
//

/// The `OpeningBook` enum is used in fetching named openings in `OpeningNamesFetcher`,
/// representing one of five ECO (Encyclopedia of Chess Openings) books that an opening line can come from.
/// It has a natural representation as a string to allow for lookup.
enum OpeningBook: String {
    case a, b, c, d, e

    /// To be able to iterate over these programmatically, it is also convertible from an integer.
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
