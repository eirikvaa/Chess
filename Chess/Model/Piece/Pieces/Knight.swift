//
//  Knight.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

struct Knight: Piece {
    var id = UUID().uuidString

    func numberOfMoves(for movePattern: MovePattern) -> Int {
        movePattern.directions.count
    }

    func validPattern(delta: Delta, side _: Side, isAttacking _: Bool) -> MovePattern {
        switch (delta.x, delta.y) {
        case (-1, 2):
            return [.north, .north, .west]
        case (1, 2):
            return [.north, .north, .east]
        case (-2, 1):
            return [.north, .west, .west]
        case (2, 1):
            return [.north, .east, .east]
        case (-2, -1):
            return [.south, .west, .west]
        case (2, -1):
            return [.south, .east, .east]
        case (-1, -2):
            return [.south, .south, .west]
        case (1, -2):
            return [.south, .south, .east]
        default:
            return []
        }
    }

    var type = PieceType.knight
    var side: Side = .white
    var graphicalRepresentation: String {
        side == .white ? "♘" : "♞"
    }

    var movePatterns: [MovePattern] = [
        [.north, .north, .west],
        [.north, .north, .east],
        [.north, .west, .west],
        [.north, .east, .east],
        [.south, .west, .west],
        [.south, .east, .east],
        [.south, .south, .west],
        [.south, .south, .east],
    ]
    var moved = false
}
