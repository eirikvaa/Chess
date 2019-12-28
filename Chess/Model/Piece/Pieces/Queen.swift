//
//  Queen.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

struct Queen: Piece {
    var type = PieceType.queen
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♕" : "♛"
    }
    var movePatterns: [MovePattern] = [
        [.north],
        [.northEast],
        [.east],
        [.southEast],
        [.south],
        [.southWest],
        [.west],
        [.northWest]
    ]
    var moved = false
    func validPattern(delta: Delta, side: Side) -> MovePattern {
        switch (delta.x, delta.y, abs(delta.x) == abs(delta.y)) {
        case (0, 1..., false):
            return [.north]
        case (1..., 1..., true):
            return [.northEast]
        case (1..., 0, false):
            return [.east]
        case (1..., (-1)..., true):
            return [.southEast]
        case (0, (-1)..., false):
            return [.south]
        case ((-1)..., (-1)..., true):
            return [.southWest]
        case ((-1)..., 0, false):
            return [.west]
        case ((-1)..., 1..., true):
            return [.northWest]
        default:
            return []
        }
    }
}
