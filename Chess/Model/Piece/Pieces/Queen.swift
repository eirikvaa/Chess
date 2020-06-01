//
//  Queen.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

struct Queen: Piece {
    var id = UUID().uuidString

    var type = PieceType.queen
    var side: Side = .white
    var graphicalRepresentation: String {
        side == .white ? "♕" : "♛"
    }

    var movePatterns: [MovePattern] = [
        [.north],
        [.northEast],
        [.east],
        [.southEast],
        [.south],
        [.southWest],
        [.west],
        [.northWest],
    ]
    var moved = false
    func validPattern(delta: Delta, side _: Side, isAttacking _: Bool) -> MovePattern {
        switch (delta.x, delta.y, delta.equalMagnitude) {
        case (0, 1..., false):
            return .init(directions: .init(repeating: .north, count: delta.magnitude(of: \.y)))
        case (1..., 1..., true):
            return .init(directions: .init(repeating: .northEast, count: delta.magnitude(of: \.y)))
        case (1..., 0, false):
            return .init(directions: .init(repeating: .east, count: delta.magnitude(of: \.x)))
        case (1..., ...(-1), true):
            return .init(directions: .init(repeating: .southEast, count: delta.magnitude(of: \.y)))
        case (0, (-1)..., false):
            return .init(directions: .init(repeating: .south, count: delta.magnitude(of: \.y)))
        case ((-1)..., (-1)..., true):
            return .init(directions: .init(repeating: .southWest, count: delta.magnitude(of: \.y)))
        case ((-1)..., 0, false):
            return .init(directions: .init(repeating: .west, count: delta.magnitude(of: \.x)))
        case ((-1)..., 1..., true):
            return .init(directions: .init(repeating: .northWest, count: delta.magnitude(of: \.y)))
        default:
            return []
        }
    }
}
