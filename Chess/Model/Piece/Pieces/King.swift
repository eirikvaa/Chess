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
