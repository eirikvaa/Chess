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
    var side: Side = .white
    var type = PieceType.pawn
    var moved = false
    var graphicalRepresentation: String {
        side == .white ? "♟" : "♙"
    }

    func validPattern(source: BoardCoordinate, destination: BoardCoordinate) -> MovePattern {
        let delta = destination - source
        
        switch (delta.x, delta.y) {
        case (0, 1...2): return MovePattern(directions: Array(repeating: Direction.north, count: delta.y))
        case (0, (-2)...(-1)): return MovePattern(directions: Array(repeating: Direction.south, count: abs(delta.y)))
        case (1, 1): return [.northEast]
        case (-1, 1): return [.northWest]
        case (1, -1): return [.southEast]
        case (-1, -1): return [.southWest]
        default: return []
        }
    }
}
