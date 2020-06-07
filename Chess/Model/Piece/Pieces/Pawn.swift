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

    func validPattern(source: BoardCoordinate, destination: BoardCoordinate, move: Move) -> MovePattern {
        let delta = destination - source
        
        switch (delta.x, delta.y, moved, move.side, move.isCapture()) {
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
            return [.southEast]
        case (-1, -1, _, .black, true):
            return [.southWest]
        default:
            return []
        }
    }
}
