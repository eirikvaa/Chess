//
//  Rook.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//

import Foundation

class Rook: Piece {
    let id = UUID()
    var content: String {
        side == .white ? "♖" : "♜"
    }
    let type: PieceType = .rook
    let side: Side
    var hasMoved = false
    let canMoveOverOtherPieces = false
    let movePatterns: [MovePattern] = [
        .continuous(.north),
        .continuous(.east),
        .continuous(.south),
        .continuous(.west)
    ]

    required init(side: Side) {
        self.side = side
    }

    var desc: String {
        "R" + content
    }
}
