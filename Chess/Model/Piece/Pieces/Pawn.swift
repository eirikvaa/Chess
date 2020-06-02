//
//  Pawn.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

struct Pawn: Piece {
    var id = UUID().uuidString

    func validPattern(delta: Delta, side: Side, isCapture: Bool) -> MovePattern {
        switch (delta.x, delta.y, moved, side, isCapture) {
        case (0, 1, false, .white, false),
             (0, 1, true, .white, false):
            return [.north]
        case (0, 2, false, .white, false):
            return [.north, .north]
        case (-1, 1, _, .white, true):
            return [.northWest]
        case (1, 1, _, .white, true):
            return [.northEast]
        case (0, -1, false, .black, false),
             (0, -1, true, .black, false):
            return [.south]
        case (0, -2, false, .black, false):
            return [.south, .south]
        case (1, -1, _, .black, true):
            return [.southWest]
        case (-1, -1, _, .black, true):
            return [.southEast]
        default:
            return []
        }
    }

    var type = PieceType.pawn
    var side: Side = .white
    var graphicalRepresentation: String {
        side == .white ? "♙" : "♟"
    }

    var movePatterns: [MovePattern] = [
        [.north],
        [.northEast],
        [.northWest],
        [.south],
        [.southWest],
        [.southEast],
    ]
    var moved = false
}
