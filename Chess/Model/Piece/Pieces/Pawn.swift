//
//  Pawn.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

struct Pawn: Piece {
    func validPattern(delta: Delta, side: Side) -> MovePattern {
        switch (delta.x, delta.y, moved, side) {
        case (0, 1...2, false, .white),
             (0, 1, true, .white):
            return [.north]
        case (-1, 1, _, .white):
            return [.northWest]
        case (1, 1, _, .white):
            return [.northEast]
        case (0, (-2)...(-1), false, .black),
             (0, -1, true, .black):
            return [.south]
        case (1, -1, _, .black):
            return [.southWest]
        case (-1, -1, _, .black):
            return [.southEast]
        default:
            return []
        }
    }
    
    var type = PieceType.pawn
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♙" : "♟"
    }
    var movePatterns: [MovePattern] = [
        [.north],
        [.northEast],
        [.northWest],
        [.south],
        [.southWest],
        [.southEast]
    ]
    var moved = false
}
