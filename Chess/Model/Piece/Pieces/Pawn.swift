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
    
    func numberOfMoves(for movePattern: MovePattern) -> Int {
        moved ? 2 : movePattern.directions.count
    }
    
    func validPattern(delta: Delta, side: Side) -> MovePattern {
        switch (delta.x, delta.y, moved, side) {
        case (0, 1, false, .white),
             (0, 1, true, .white):
            return [.north]
        case (0, 2, false, .white):
            return [.north, .north]
        case (-1, 1, _, .white):
            return [.northWest]
        case (1, 1, _, .white):
            return [.northEast]
        case (0, -1, false, .black),
             (0, -1, true, .black):
            return [.south]
        case (0, -2, false, .black):
            return [.south, .south]
        case (1, -1, _, .black):
            return [.southWest]
        case (-1, -1, _, .black):
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
        [.southEast]
    ]
    var moved = false
}
