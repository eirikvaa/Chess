//
//  Move2.swift
//  Chess
//
//  Created by Eirik Vale Aase on 05/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

struct Move {
    enum MoveValidationError: Error {
        case wrongMoveFormat
    }
    
    let destination: Coordinate
    let pieceType: PieceType
    var isCapture = false
    
    init(rawMove: String) throws {
        /// [N|R|B|Q|K]?    : Optional horthand for type of piece. No shorthand means pawn.
        /// x?              : Optional capture
        /// [a-h][1-7]      : File and rank.
        let regex = #"[N|R|B|Q|K]?x?[a-h][1-8]"#
        
        guard let match = rawMove.range(of: regex, options: .regularExpression) else {
            throw MoveValidationError.wrongMoveFormat
        }
        
        var validRawMove = String(rawMove[match])
        
        var (rawDestination, rest) = validRawMove.removeSuffix(count: 2)
        
        self.destination = try Coordinate(rawCoordinates: rawDestination)
        
        if rest.last == "x" {
            isCapture = true
            rest.removeLast()
        }
        
        self.pieceType = PieceType(rawPiece: rest)
    }
}
