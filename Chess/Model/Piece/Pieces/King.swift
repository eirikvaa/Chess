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
    
    func numberOfMoves(for movePattern: MovePattern) -> Int {
        1
    }
    
    var type = PieceType.king
    var side: Side = .white
    var graphicalRepresentation: String {
        side == .white ? "♔" : "♚"
    }
    var movePatterns: [MovePattern] = [
        [.north],
        [.east],
        [.south],
        [.west]
    ]
    var moved = false
    func validPattern(delta: Delta, side: Side, isAttacking: Bool) -> MovePattern {
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
