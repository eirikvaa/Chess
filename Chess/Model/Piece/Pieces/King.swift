//
//  King.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

class King: Piece {
    let id = UUID()
    var content: String {
        side == .white ? "♔" : "♚"
    }
    let type: PieceType = .king
    let side: Side
    var hasMoved: Bool = false
    let canMoveOverOtherPieces = false
    let movePatterns: [MovePattern] = [
        .single(.north),
        .single(.northEast),
        .single(.east),
        .single(.southEast),
        .single(.south),
        .single(.southWest),
        .single(.west),
        .single(.northWest)
    ]

    required init(side: Side) {
        self.side = side
    }

    var desc: String {
        "K" + content
    }
}
