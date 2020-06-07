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
    var side: Side = .white
    var type = PieceType.knight
    var moved = false
    var graphicalRepresentation: String {
        side == .white ? "♞" : "♘"
    }
    
    func validPattern(source: BoardCoordinate, destination: BoardCoordinate, move: Move) -> MovePattern {
        let delta = destination - source
        
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
}
