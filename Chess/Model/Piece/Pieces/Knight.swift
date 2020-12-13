//
//  Knight.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

class Knight: Piece {
    var id = UUID()
    var content: String {
        side == .white ? "♘" : "♞"
    }
    var type: PieceType = .knight
    var side: Side = .white
    var hasMoved: Bool = false
    var canMoveOverOtherPieces = true
    var movePatterns: [MovePattern] {
        [
            MovePattern(moveType: .shape, directions: .north, .north, .west),
            MovePattern(moveType: .shape, directions: .north, .north, .east),
            MovePattern(moveType: .shape, directions: .west, .west, .north),
            MovePattern(moveType: .shape, directions: .west, .west, .south),
            MovePattern(moveType: .shape, directions: .south, .south, .west),
            MovePattern(moveType: .shape, directions: .south, .south, .east),
            MovePattern(moveType: .shape, directions: .east, .east, .north),
            MovePattern(moveType: .shape, directions: .east, .east, .south)
        ]
    }

    required init(side: Side) {
        self.side = side
    }

    var desc: String {
        "N" + content
    }
}
