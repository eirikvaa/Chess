//
//  Queen.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//

import Foundation

class Queen: Piece {
    let id = UUID()
    var content: String {
        side == .white ? "♕" : "♛"
    }
    let type: PieceType = .queen
    let side: Side
    var hasMoved = false
    let canMoveOverOtherPieces = false
    let movePatterns: [MovePattern] = [
        .continuous(.north),
        .continuous(.northEast),
        .continuous(.east),
        .continuous(.southEast),
        .continuous(.south),
        .continuous(.southWest),
        .continuous(.west),
        .continuous(.northWest)
    ]

    required init(side: Side) {
        self.side = side
    }

    var desc: String {
        "Q" + content
    }
}
