//
//  Knight.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

struct Knight: Piece {
    func validPattern(fileDelta: Int, rowDelta: Int, side: Side) -> MovePattern {
        switch (fileDelta, rowDelta) {
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
    
    var type = PieceType.knight
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♘" : "♞"
    }
    var movePatterns: [MovePattern] = [
        [.north, .north, .west],
        [.north, .north, .east],
        [.north, .west, .west],
        [.north, .east, .east],
        [.south, .west, .west],
        [.south, .east, .east],
        [.south, .south, .west],
        [.south, .south, .east]
    ]
    var moved = false
}
