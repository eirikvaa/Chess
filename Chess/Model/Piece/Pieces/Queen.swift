//
//  Queen.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

class Queen: Piece {
    let id = UUID()
    var content: String {
        side == .white ? "♕" : "♛"
    }
    var type: PieceType = .queen
    var side: Side = .white
    var hasMoved: Bool = false
    var canMoveOverOtherPieces = false
    var movePatterns: [MovePattern] = [
        MovePattern(moveType: .continuous, directions: .north),
        MovePattern(moveType: .continuous, directions: .northEast),
        MovePattern(moveType: .continuous, directions: .east),
        MovePattern(moveType: .continuous, directions: .southEast),
        MovePattern(moveType: .continuous, directions: .south),
        MovePattern(moveType: .continuous, directions: .southWest),
        MovePattern(moveType: .continuous, directions: .west),
        MovePattern(moveType: .continuous, directions: .northWest)
    ]

    required init(side: Side) {
        self.side = side
    }
}
