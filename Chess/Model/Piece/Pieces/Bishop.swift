//
//  Bishop.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

struct Bishop: Piece {
    var id = UUID().uuidString
    var side: Side = .white
    var type = PieceType.bishop
    var moved = false
    var graphicalRepresentation: String {
        side == .white ? "♝" : "♗"
    }

    func validPattern(delta: Delta, side _: Side, isCapture _: Bool) -> MovePattern {
        guard delta.equalMagnitude else {
            return .init(directions: [])
        }

        switch (delta.x, delta.y) {
        case (1..., 1...):
            return .init(directions: .init(repeating: .northEast, count: delta.magnitude(of: \.x)))
        case (...(-1), ...(-1)):
            return .init(directions: .init(repeating: .southWest, count: delta.magnitude(of: \.x)))
        case (1..., ...(-1)):
            return .init(directions: .init(repeating: .southEast, count: delta.magnitude(of: \.x)))
        case (...(-1), 1...):
            return .init(directions: .init(repeating: .northWest, count: delta.magnitude(of: \.x)))
        default:
            return []
        }
    }
}
