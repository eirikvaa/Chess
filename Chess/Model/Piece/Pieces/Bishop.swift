//
//  Bishop.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

class Bishop: Piece {
    var id = UUID()
    var content: String {
        side == .white ? "♗" : "♝"
    }
    var type: PieceType = .bishop
    var side: Side = .white
    var hasMoved: Bool = false
    var canMoveOverOtherPieces = false
    var movePatterns: [MovePattern] = [
        MovePattern(moveType: .continuous, directions: .northWest),
        MovePattern(moveType: .continuous, directions: .northEast),
        MovePattern(moveType: .continuous, directions: .southWest),
        MovePattern(moveType: .continuous, directions: .southEast)
    ]

    required init(side: Side) {
        self.side = side
    }

    var desc: String {
        "B" + content
    }
}
