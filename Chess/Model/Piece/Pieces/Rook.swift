//
//  Rook.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

class Rook: Piece {
    var id = UUID()
    var content: String {
        side == .white ? "♖" : "♜"
    }
    var type: PieceType = .rook
    var side: Side = .white
    var hasMoved: Bool = false
    var canMoveOverOtherPieces = false
    var movePatterns: [MovePattern] = [
        MovePattern(moveType: .straight, directions: .north),
        MovePattern(moveType: .straight, directions: .east),
        MovePattern(moveType: .straight, directions: .south),
        MovePattern(moveType: .straight, directions: .west)
    ]

    required init(side: Side) {
        self.side = side
    }

    var desc: String {
        "R" + content
    }
}
