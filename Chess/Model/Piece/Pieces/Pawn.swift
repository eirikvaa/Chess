//
//  Pawn.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

/**
 Pawns are the least valuable pieces on the board. Their move patterns depend on the state
 at which they are in, specifically if they have moved or not from before. If they have not moved yet,
 they can move ahead two cells. If not, they can only move one cell.
 */

class Pawn: Piece, Identifiable {
    let id = UUID()
    var content: String {
        side == .white ? "♙" : "♟"
    }
    var type: PieceType = .pawn
    var side: Side = .white
    var hasMoved: Bool = false
    var canMoveOverOtherPieces = false
    var movePatterns: [MovePattern] {
        switch (hasMoved, side) {
        case (false, .white):
            return [
                MovePattern(moveType: .single, directions: .north),
                MovePattern(moveType: .double, directions: .north, .north),
                MovePattern(moveType: .diagonal, directions: .northWest),
                MovePattern(moveType: .diagonal, directions: .northEast)
            ]
        case (true, .white):
            return [
                MovePattern(moveType: .single, directions: .north),
                MovePattern(moveType: .diagonal, directions: .northWest),
                MovePattern(moveType: .diagonal, directions: .northEast)
            ]
        case (false, .black):
            return [
                MovePattern(moveType: .single, directions: .south),
                MovePattern(moveType: .double, directions: .south, .south),
                MovePattern(moveType: .diagonal, directions: .southWest),
                MovePattern(moveType: .diagonal, directions: .southEast)
            ]
        case (true, .black):
            return [
                MovePattern(moveType: .single, directions: .south),
                MovePattern(moveType: .diagonal, directions: .southWest),
                MovePattern(moveType: .diagonal, directions: .southEast)
            ]
        }
    }

    required init(side: Side) {
        self.side = side
    }
    
    var desc: String {
        "P" + content
    }
}
