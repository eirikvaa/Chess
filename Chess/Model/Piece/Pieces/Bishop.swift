//
//  Bishop.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

class Bishop: Piece {
    let id = UUID()
    var content: String {
        side == .white ? "♗" : "♝"
    }
    let type: PieceType = .bishop
    let side: Side
    var hasMoved: Bool = false
    let canMoveOverOtherPieces = false
    let movePatterns: [MovePattern] = [
        .continuous(.northWest),
        .continuous(.northEast),
        .continuous(.southWest),
        .continuous(.southEast)
    ]

    required init(side: Side) {
        self.side = side
    }

    var desc: String {
        "B" + content
    }
}
