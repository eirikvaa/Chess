//
//  Move.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

/**
 A move that can be applied to a piece.
 The initializer validates the move and throws if it's not legal based on the regex.
 */
struct Move {
    enum MoveValidationError: Error {
        case wrongMoveFormat
    }

    /// The destination that is encoded in the move.
    let destination: Coordinate

    /// The piece type that is encoded in the move.
    let pieceType: PieceType

    /// Whether or not the move is a capture, i.e. it captures another piece.
    let isCapture: Bool

    var source: Coordinate?

    /// TODO: This initializer only supports a subset of possible moves. Expand when API for pieces
    /// and boards converge to something meaningful.
    init(rawMove: String) throws {
        /// [N|R|B|Q|K]?    : Optional horthand for type of piece. No shorthand means pawn.
        /// x?              : Optional capture
        /// [a-h][1-7]      : File and rank.
        let regex = #"[N|R|B|Q|K]?([a-h]?[1-8]?)?x?[a-h][1-8]"#

        guard let match = rawMove.range(of: regex, options: .regularExpression) else {
            throw MoveValidationError.wrongMoveFormat
        }

        var validRawMove = String(rawMove[match])

        var (rawDestination, rest) = validRawMove.removeSuffix(count: 2)

        self.destination = try Coordinate(rawCoordinates: rawDestination)

        if rest.last == "x" {
            isCapture = true
            rest.removeLast()
        } else {
            isCapture = false
        }

        var rawPiece = ""
        if rest.count > 1 {
            let (suffix, rest) = rest.removeSuffix(count: 2)
            rawPiece = rest
            self.source = Coordinate(stringLiteral: suffix)
        } else {
            rawPiece = rest
        }

        self.pieceType = PieceType(rawPiece: rawPiece)
    }
}
