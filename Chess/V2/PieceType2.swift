//
//  PieceType2.swift
//  Chess
//
//  Created by Eirik Vale Aase on 05/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
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
 Directions as seen from the perspective of the white player (towards the black player).
 Avoid adding north-west, et cetera, as those can be composed from these four.
 */
enum Direction: CustomStringConvertible {
    case north
    case northWest
    case northEast
    case east
    case south
    case southWest
    case southEast
    case west

    var description: String {
        switch self {
        case .north: return "N"
        case .northWest: return "NW"
        case .northEast: return "NE"
        case .east: return "E"
        case .south: return "S"
        case .southWest: return "SW"
        case .southEast: return "SE"
        case .west: return "W"
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

/**
 A move pattern consists of a move type and a list of directions.
 */
struct MovePattern: Equatable, CustomStringConvertible {
    let moveType: MoveType
    let directions: [Direction]

    init(moveType: MoveType, directions: Direction...) {
        self.moveType = moveType
        self.directions = directions
    }

    init(moveType: MoveType, directions: [Direction]) {
        self.moveType = moveType
        self.directions = directions
    }

    var description: String {
        directions.map {
            String(describing: $0)
        }.joined(separator: "-")
    }
}

/**
 A piece on the board.
 */
protocol Piece: AnyObject {
    /// An ID for the piece. Only used to locate pieces on the board.
    var id: UUID { get }

    /// The graphical representation of the piece, Unicode symbols.
    var content: String { get }

    /// The type of piece
    var type: PieceType { get }

    /// The side that owns the piece
    var side: Side { get set }

    /// If the piece has made its first move yet
    var hasMoved: Bool { get set }

    /// A list of ways in which the piece can move.
    var movePatterns: [MovePattern] { get }

    var canMoveOverOtherPieces: Bool { get }

    /// Initialize a piece with the given side. This is really the only information that is not known
    /// at the time it is initialized.
    init(side: Side)
}

/**
 Pawns are the least valuable pieces on the board. Their move patterns depend on the state
 at which they are in, specifically if they have moved or not from before. If they have not moved yet,
 they can move ahead two cells. If not, they can only move one cell.
 */

class Pawn: Piece, Identifiable {
    let id = UUID()
    var content: String {
        side == .white ? "♙" : "♟"
    }
    var type: PieceType = .pawn
    var side: Side = .white
    var hasMoved: Bool = false
    var canMoveOverOtherPieces = false
    var movePatterns: [MovePattern] {
        switch (hasMoved, side) {
        case (false, .white):
            return [
                MovePattern(moveType: .single, directions: .north),
                MovePattern(moveType: .double, directions: .north, .north),
                MovePattern(moveType: .diagonal, directions: .northWest),
                MovePattern(moveType: .diagonal, directions: .northEast)
            ]
        case (true, .white):
            return [
                MovePattern(moveType: .single, directions: .north),
                MovePattern(moveType: .diagonal, directions: .northWest),
                MovePattern(moveType: .diagonal, directions: .northEast)
            ]
        case (false, .black):
            return [
                MovePattern(moveType: .single, directions: .south),
                MovePattern(moveType: .double, directions: .south, .south),
                MovePattern(moveType: .diagonal, directions: .southWest),
                MovePattern(moveType: .diagonal, directions: .southEast)
            ]
        case (true, .black):
            return [
                MovePattern(moveType: .single, directions: .south),
                MovePattern(moveType: .diagonal, directions: .southWest),
                MovePattern(moveType: .diagonal, directions: .southEast)
            ]
        }
    }

    required init(side: Side) {
        self.side = side
    }
}

/*
class Rook: Piece {
    var id = UUID()
    var content: String {
        side == .white ? "♖" : "♜"
    }
    var type: PieceType = .rook
    var side: Side = .white
    var hasMoved: Bool = false
    var movePatterns: [MovePattern] { [
        MovePattern(moveType: .straight, directions: .north),
        MovePattern(moveType: .straight, directions: .east),
        MovePattern(moveType: .straight, directions: .south),
        MovePattern(moveType: .straight, directions: .west)
    ]}
    
    required init(side: Side) {
        self.side = side
    }
}

class Bishop: Piece {
    var content: String {
        side == .white ? "♗" : "♝"
    }
    var type: PieceType = .bishop
    var side: Side = .white
    var hasMoved: Bool = false
    var movePatterns = MovePatterns(patterns: [
        MovePattern((.continuous, [.north, .east])),
        MovePattern((.continuous, [.south, .east])),
        MovePattern((.continuous, [.south, .west])),
        MovePattern((.continuous, [.north, .west]))
    ])
    
    required init(side: Side) {
        self.side = side
    }
}
*/
/*
class Knight: Piece {
    var id = UUID()
    var content: String {
        side == .white ? "♘" : "♞"
    }
    var type: PieceType = .knight
    var side: Side = .white
    var hasMoved: Bool = false
    var movePatterns: [MovePattern] {
        [
            MovePattern(moveType: .shape, directions: .north, .north, .west),
            MovePattern(moveType: .shape, directions: .north, .north, .east),
            MovePattern(moveType: .shape, directions: .west, .west, .north),
            MovePattern(moveType: .shape, directions: .west, .west, .south),
            MovePattern(moveType: .shape, directions: .south, .south, .west),
            MovePattern(moveType: .shape, directions: .south, .south, .east),
            MovePattern(moveType: .shape, directions: .east, .east, .north),
            MovePattern(moveType: .shape, directions: .east, .east, .south),
        ]
    }
    
    required init(side: Side) {
        self.side = side
    }
}
*/
class Queen: Piece {
    var id = UUID()
    var content: String {
        side == .white ? "♕" : "♛"
    }
    var type: PieceType = .queen
    var side: Side = .white
    var hasMoved: Bool = false
    var canMoveOverOtherPieces = false
    var movePatterns: [MovePattern] = [
        MovePattern(moveType: .continuous, directions: .north),
        MovePattern(moveType: .continuous, directions: .northEast),
        MovePattern(moveType: .continuous, directions: .east),
        MovePattern(moveType: .continuous, directions: .southEast),
        MovePattern(moveType: .continuous, directions: .south),
        MovePattern(moveType: .continuous, directions: .southWest),
        MovePattern(moveType: .continuous, directions: .west),
        MovePattern(moveType: .continuous, directions: .northWest)
    ]

    required init(side: Side) {
        self.side = side
    }
}
/*
class King: Piece {
    var id = UUID()
    var content: String {
        side == .white ? "♔" : "♚"
    }
    var type: PieceType = .king
    var side: Side = .white
    var hasMoved: Bool = false
    var movePatterns: [MovePattern] = [
        MovePattern(moveType: .single, directions: .north),
        MovePattern(moveType: .single, directions: .northEast),
        MovePattern(moveType: .single, directions: .east),
        MovePattern(moveType: .single, directions: .southEast),
        MovePattern(moveType: .single, directions: .south),
        MovePattern(moveType: .single, directions: .southWest),
        MovePattern(moveType: .single, directions: .west),
        MovePattern(moveType: .single, directions: .northWest)
    ]
    
    required init(side: Side) {
        self.side = side
    }
}
*/
