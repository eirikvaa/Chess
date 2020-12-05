//
//  King.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

struct King: Piece, Identifiable {
    var id = UUID()
    var side: Side = .white
    var type = PieceType.king
    var moved = false
    var graphicalRepresentation: String {
        side == .white ? "♚" : "♔"
    }
    var validPatterns: [MovePattern] {
        [
            [.north],
            [.northEast],
            [.east],
            [.southEast],
            [.south],
            [.southWest],
            [.west],
            [.northWest]
        ]
    }
    
    func validPattern(source: BoardCoordinate, destination: BoardCoordinate) -> MovePattern {
        let delta = destination - source
        
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
