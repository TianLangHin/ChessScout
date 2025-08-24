//
//  IdWrapper.swift
//  ChessScout
//
//  Created by Tian Lang Hin on 24/8/2025.
//

import Foundation

struct IdWrapper<Inner>: Identifiable {
    let id = UUID()
    var data: Inner
}
