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
    var movePatterns: [MovePattern] = [
        .shape([.north, .north, .west]),
        .shape([.north, .north, .east]),
        .shape([.west, .west, .north]),
        .shape([.west, .west, .south]),
        .shape([.south, .south, .west]),
        .shape([.south, .south, .east]),
        .shape([.east, .east, .north]),
        .shape([.east, .east, .south])
    ]

    required init(side: Side) {
        self.side = side
    }

    var desc: String {
        "N" + content
    }
}
