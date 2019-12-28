//
//  Piece.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

enum Direction {
    case north
    case northEast
    case east
    case southEast
    case south
    case southWest
    case west
    case northWest
    
    var oppositeDirection: Direction {
        switch self {
        case .north: return .south
        case .northEast: return .southWest
        case .east: return .west
        case .southEast: return .northWest
        case .south: return .north
        case .southWest: return .northEast
        case .west: return .east
        case .northWest: return .southEast
        }
    }
    
    func sideRelativeDirection(_ side: Side) -> Direction {
        switch side {
        case .white: return self
        case .black: return self.oppositeDirection
        }
        
    }
}

extension Direction: CustomStringConvertible {
    var description: String {
        switch self {
        case .north: return "N"
        case .northEast: return "NE"
        case .east: return "E"
        case .southEast: return "SE"
        case .south: return "S"
        case .southWest: return "SW"
        case .west: return "W"
        case .northWest: return "NW"
        }
    }
}

struct MovePattern {
    let directions: [Direction]
}

extension MovePattern: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Direction...) {
        self.directions = elements
    }
}

extension MovePattern: Equatable {
    static func == (lhs: MovePattern, rhs: MovePattern) -> Bool {
        lhs.directions == rhs.directions
    }
}

extension MovePattern: CustomStringConvertible {
    var description: String {
        guard directions.count > 0 else {
            return "[]"
        }
        
        guard directions.count > 1 else {
            return "\(directions[0])"
        }
        
        var _description = "["
        
        for pattern in directions {
            _description += "\(pattern.description)\t→\t"
        }
        
        _description += "]"
        
        return _description
    }
}

enum PieceType {
    case king
    case queen
    case bishop
    case knight
    case rook
    case pawn
}

struct PieceFabric {
    static func create(_ type: PieceType) -> Piece {
        switch type {
        case .king: return King()
        case .queen: return Queen()
        case .bishop: return Bishop()
        case .knight: return Knight()
        case .rook: return Rook()
        case .pawn: return Pawn()
        }
    }
}

protocol Piece {
    var type: PieceType { get }
    var player: Player? { get set }
    var graphicalRepresentation: String { get }
    var movePatterns: [MovePattern] { get }
    var moved: Bool { get set }
    
    func validPattern(fileDelta: Int, rowDelta: Int, side: Side) -> MovePattern
}

struct King: Piece {
    var type = PieceType.king
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♔" : "♚"
    }
    var movePatterns: [MovePattern] = [
        [.north],
        [.east],
        [.south],
        [.west]
    ]
    var moved = false
    func validPattern(fileDelta: Int, rowDelta: Int, side: Side) -> MovePattern {
        switch (fileDelta, rowDelta) {
        case (0, 1):
            return [.north]
        case (1, 1):
            return [.northEast]
        case (1, 0):
            return [.east]
        case (1, -1):
            return [.southEast]
        case (0, -1):
            return [.south]
        case (-1, -1):
            return [.southWest]
        case (-1, 0):
            return [.west]
        case (-1, 1):
            return [.northWest]
        default:
            return []
        }
    }
}

struct Queen: Piece {
    var type = PieceType.queen
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♕" : "♛"
    }
    var movePatterns: [MovePattern] = [
        [.north],
        [.northEast],
        [.east],
        [.southEast],
        [.south],
        [.southWest],
        [.west],
        [.northWest]
    ]
    var moved = false
    func validPattern(fileDelta: Int, rowDelta: Int, side: Side) -> MovePattern {
       switch (fileDelta, rowDelta, abs(fileDelta) == abs(rowDelta)) {
        case (0, 1..., false):
            return [.north]
        case (1..., 1..., true):
            return [.northEast]
        case (1..., 0, false):
            return [.east]
        case (1..., (-1)..., true):
            return [.southEast]
        case (0, (-1)..., false):
            return [.south]
        case ((-1)..., (-1)..., true):
            return [.southWest]
        case ((-1)..., 0, false):
            return [.west]
        case ((-1)..., 1..., true):
            return [.northWest]
        default:
            return []
        }
    }
}

struct Bishop: Piece {
    func validPattern(fileDelta: Int, rowDelta: Int, side: Side) -> MovePattern {
        guard abs(fileDelta) == abs(rowDelta) else {
            return .init(directions: [])
        }
        
        switch (fileDelta, rowDelta) {
        case (1..., 1...):
            return [.northEast]
        case (...(-1), ...(-1)):
            return [.southWest]
        case (1..., ...(-1)):
            return [.southEast]
        case (...(-1), 1...):
            return [.northWest]
        default:
            return []
        }
    }
    
    var type = PieceType.bishop
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♗" : "♝"
    }
    var movePatterns: [MovePattern] = [
        [.northEast],
        [.southEast],
        [.southWest],
        [.northWest],
    ]
    var moved = false
}

struct Rook: Piece {
    func validPattern(fileDelta: Int, rowDelta: Int, side: Side) -> MovePattern {
        switch (fileDelta, rowDelta) {
        case (1..., 0):
            return side == .white ? [.east] : [.west]
        case (...(-1), 0):
            return side == .white ? [.west] : [.east]
        case (0, 1...):
            return side == .white ? [.north] : [.south]
        case (0, ...(-2)):
            return side == .white ? [.south] : [.north]
        default:
            return []
        }
    }
    
    var type = PieceType.rook
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♖" : "♜"
    }
    var movePatterns: [MovePattern] = [
        [.north],
        [.west],
        [.east],
        [.south]
    ]
    var moved = false
}

struct Knight: Piece {
    func validPattern(fileDelta: Int, rowDelta: Int, side: Side) -> MovePattern {
        switch (fileDelta, rowDelta) {
        case (-1, 2):
            return [.north, .north, .west]
        case (1, 2):
            return [.north, .north, .east]
        case (-2, 1):
            return [.north, .west, .west]
        case (2, 1):
            return [.north, .east, .east]
        case (-2, -1):
            return [.south, .west, .west]
        case (2, -1):
            return [.south, .east, .east]
        case (-1, -2):
            return [.south, .south, .west]
        case (1, -2):
            return [.south, .south, .east]
        default:
            return []
        }
    }
    
    var type = PieceType.knight
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♘" : "♞"
    }
    var movePatterns: [MovePattern] = [
        [.north, .north, .west],
        [.north, .north, .east],
        [.north, .west, .west],
        [.north, .east, .east],
        [.south, .west, .west],
        [.south, .east, .east],
        [.south, .south, .west],
        [.south, .south, .east]
    ]
    var moved = false
}

struct Pawn: Piece {
    func validPattern(fileDelta: Int, rowDelta: Int, side: Side) -> MovePattern {
        switch (fileDelta, rowDelta, moved, side) {
        case (0, 1...2, false, .white),
             (0, 1, true, .white):
            return [.north]
        case (-1, 1, _, .white):
            return [.northWest]
        case (1, 1, _, .white):
            return [.northEast]
        case (0, (-2)...(-1), false, .black),
             (0, -1, true, .black):
            return [.south]
        case (1, -1, _, .black):
            return [.southWest]
        case (-1, -1, _, .black):
            return [.southEast]
        default:
            return []
        }
    }
    
    var type = PieceType.pawn
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♙" : "♟"
    }
    var movePatterns: [MovePattern] = [
        [.north],
        [.northEast],
        [.northWest],
        [.south],
        [.southWest],
        [.southEast]
    ]
    var moved = false
}
