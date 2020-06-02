//
//  King.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

struct King: Piece {
    var id = UUID().uuidString
    var side: Side = .white
    var type = PieceType.king
    var moved = false
    var graphicalRepresentation: String {
        side == .white ? "♔" : "♚"
    }
    
    func validPattern(delta: Delta, side _: Side, isCapture _: Bool) -> MovePattern {
        switch (delta.x, delta.y) {
        case (0, 1):
            return [.north]
        case (1, 1):
            return [.northEast]
        case (1, 0):
            return [.east]
        case (1, -1):
            return [.southEast]
        case (0, -1):
            return [.south]
        case (-1, -1):
            return [.southWest]
        case (-1, 0):
            return [.west]
        case (-1, 1):
            return [.northWest]
        default:
            return []
        }
    }
}
