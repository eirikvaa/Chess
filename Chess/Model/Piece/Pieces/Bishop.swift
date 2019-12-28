//
//  Bishop.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

struct Bishop: Piece {
    func validPattern(delta: Delta, side: Side) -> MovePattern {
        guard delta.equalMagnitude else {
            return .init(directions: [])
        }
        
        switch (delta.x, delta.y) {
        case (1..., 1...):
            return [.northEast]
        case (...(-1), ...(-1)):
            return [.southWest]
        case (1..., ...(-1)):
            return [.southEast]
        case (...(-1), 1...):
            return [.northWest]
        default:
            return []
        }
    }
    
    var type = PieceType.bishop
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♗" : "♝"
    }
    var movePatterns: [MovePattern] = [
        [.northEast],
        [.southEast],
        [.southWest],
        [.northWest],
    ]
    var moved = false
}
