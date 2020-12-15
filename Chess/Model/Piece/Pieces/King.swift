//
//  King.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

class King: Piece {
    var id = UUID()
    var content: String {
        side == .white ? "♔" : "♚"
    }
    var type: PieceType = .king
    var side: Side = .white
    var hasMoved: Bool = false
    var canMoveOverOtherPieces = false
    var movePatterns: [MovePattern] = [
        MovePattern(moveType: .single, directions: .north),
        MovePattern(moveType: .single, directions: .northEast),
        MovePattern(moveType: .single, directions: .east),
        MovePattern(moveType: .single, directions: .southEast),
        MovePattern(moveType: .single, directions: .south),
        MovePattern(moveType: .single, directions: .southWest),
        MovePattern(moveType: .single, directions: .west),
        MovePattern(moveType: .single, directions: .northWest)
    ]
    
    required init(side: Side) {
        self.side = side
    }

    var desc: String {
        "K" + content
    }
}
