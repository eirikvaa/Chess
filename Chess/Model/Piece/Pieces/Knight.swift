//
//  Knight.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

class Knight: Piece {
    let id = UUID()
    var content: String {
        side == .white ? "♘" : "♞"
    }
    let type: PieceType = .knight
    let side: Side
    var hasMoved: Bool = false
    let canMoveOverOtherPieces = true
    var movePatterns: [MovePattern] = [
        .shape(.north, .north, .west),
        .shape(.north, .north, .east),
        .shape(.west, .west, .south),
        .shape(.west, .west, .north),
        .shape(.south, .south, .west),
        .shape(.south, .south, .east),
        .shape(.east, .east, .north),
        .shape(.east, .east, .south)
    ]

    required init(side: Side) {
        self.side = side
    }

    var desc: String {
        "N" + content
    }
}
