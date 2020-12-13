//
//  PieceType.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

/**
 The type of the piece.
 */
enum PieceType {
    case pawn
    case bishop
    case knight
    case rook
    case queen
    case king

    init(rawPiece: String) {
        switch rawPiece {
        case "B": self = .bishop
        case "N": self = .knight
        case "R": self = .rook
        case "Q": self = .queen
        case "K": self = .king
        default: self = .pawn
        }
    }
}

/**
 Moves differ between the pieces and the state for which a piece is in.
  - `.single` and `.double` are used by pawns and kings.
 */
enum MoveType {
    case straight
    case diagonal
    case single
    case double
    case shape
    case continuous
}
