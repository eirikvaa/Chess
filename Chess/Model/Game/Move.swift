//
//  Move.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

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

/**
 A move that can be applied to a piece.
 The initializer validates the move and throws if it's not legal based on the regex.
 */
struct Move: CustomStringConvertible {
    enum MoveValidationError: Error {
        case wrongMoveFormat
    }

    /// The string representation of the move
    let rawMove: String

    /// The destination that is encoded in the move.
    let destination: Coordinate?

    /// The piece type that is encoded in the move.
    /// In castling, this is the king
    let pieceType: PieceType

    /// In castling, this is the rook
    var secondaryPieceType: PieceType?

    /// Whether or not the move is a capture, i.e. it captures another piece.
    let isCapture: Bool

    /// O-O-O, the longest
    let isQueenSideCastling: Bool

    /// O-O, the shortest
    let isKingSideCastling: Bool

    /// Might be a partial source coordinate if used for disambiguation
    var source: Coordinate

    /// We don't know if a move is an en passant merely by the raw move, but we'll know it later
    /// when the pawn captures an empty cell and an opposite pawn that hasn't moved yet moves
    /// a double move and is side-by-side with the first pawn.
    var isEnPassant = false

    /// TODO: This initializer only supports a subset of possible moves. Expand when API for pieces
    /// and boards converge to something meaningful.
    init(rawMove: String) throws {
        self.rawMove = rawMove

        if rawMove == "O-O-O" || rawMove == "O-O" {
            destination = nil
            isCapture = false
            isQueenSideCastling = rawMove == "O-O-O"
            isKingSideCastling = rawMove == "O-O"
            pieceType = .king
            secondaryPieceType = .rook
            source = Coordinate(file: nil, rank: nil)
            return
        }

        self.isQueenSideCastling = false
        self.isKingSideCastling = false

        /// [N|R|B|Q|K]?    : Optional horthand for type of piece. No shorthand means pawn.
        /// x?              : Optional capture
        /// [a-h][1-7]      : File and rank.
        let regex = #"([N|R|B|Q|K]?([a-h]?[1-8]?)?x?[a-h][1-8])||(O-O-O)||(O-O)"#

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
        var file: String?
        var rank: String?

        if rest.first?.isUppercase == true {
            rawPiece = String(rest.removeFirst())
        }

        self.pieceType = PieceType(rawPiece: rawPiece)

        if rest.count == 2 { // [letter][number]
            if let letter = rest.first, let number = rest.last {
                file = String(letter)
                rank = String(number)
            }
        } else { // [letter] or [number]
            if let letter = rest.first, letter.isLetter {
                file = String(letter)
            } else if let number = rest.first, number.isNumber {
                rank = String(number)
            }
        }

        if let file = file, let rank = rank, let rInt = Int(rank) {
            let ffile = File(stringLiteral: file)
            let rrank = Rank(integerLiteral: rInt)
            self.source = Coordinate(file: ffile, rank: rrank)
        } else if let file = file {
            let ffile = File(stringLiteral: file)
            self.source = Coordinate(file: ffile, rank: nil)
        } else if let rank = rank, let rInt = Int(rank) {
            let rrank = Rank(integerLiteral: rInt)
            self.source = Coordinate(file: nil, rank: rrank)
        } else {
            self.source = Coordinate(file: nil, rank: nil)
        }
    }

    var description: String {
        rawMove
    }
}
