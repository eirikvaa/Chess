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

extension MovePattern: CustomStringConvertible {
    var description: String {
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
        .init(directions: [.north]),
        .init(directions: [.east]),
        .init(directions: [.south]),
        .init(directions: [.west])
    ]
    var moved = false
    func validPattern(fileDelta: Int, rowDelta: Int, side: Side) -> MovePattern {
        switch (fileDelta, rowDelta) {
        case (0, 1):
            return .init(directions: [.north])
        case (1, 1):
            return .init(directions: [.northEast])
        case (1, 0):
            return .init(directions: [.east])
        case (1, -1):
            return .init(directions: [.southEast])
        case (0, -1):
            return .init(directions: [.south])
        case (-1, -1):
            return .init(directions: [.southWest])
        case (-1, 0):
            return .init(directions: [.west])
        case (-1, 1):
            return .init(directions: [.northWest])
        default:
            return .init(directions: [])
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
        .init(directions: [.north]),
        .init(directions: [.northEast]),
        .init(directions: [.east]),
        .init(directions: [.southEast]),
        .init(directions: [.south]),
        .init(directions: [.southWest]),
        .init(directions: [.west]),
        .init(directions: [.northWest])
    ]
    var moved = false
    func validPattern(fileDelta: Int, rowDelta: Int, side: Side) -> MovePattern {
       switch (fileDelta, rowDelta, abs(fileDelta) == abs(rowDelta)) {
        case (0, 1..., false):
            return .init(directions: [.north])
        case (1..., 1..., true):
            return .init(directions: [.northEast])
        case (1..., 0, false):
            return .init(directions: [.east])
        case (1..., (-1)..., true):
            return .init(directions: [.southEast])
        case (0, (-1)..., false):
            return .init(directions: [.south])
        case ((-1)..., (-1)..., true):
            return .init(directions: [.southWest])
        case ((-1)..., 0, false):
            return .init(directions: [.west])
        case ((-1)..., 1..., true):
            return .init(directions: [.northWest])
        default:
            return .init(directions: [])
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
            return .init(directions: [.northEast])
        case (...(-1), ...(-1)):
            return .init(directions: [.southWest])
        case (1..., ...(-1)):
            return .init(directions: [.southEast])
        case (...(-1), 1...):
            return .init(directions: [.northWest])
        default:
            return .init(directions: [])
        }
    }
    
    var type = PieceType.bishop
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♗" : "♝"
    }
    var movePatterns: [MovePattern] = [
        .init(directions: [.northEast]),
        .init(directions: [.southEast]),
        .init(directions: [.southWest]),
        .init(directions: [.northWest]),
    ]
    var moved = false
}

struct Rook: Piece {
    func validPattern(fileDelta: Int, rowDelta: Int, side: Side) -> MovePattern {
        switch (fileDelta, rowDelta) {
        case (1..., 0):
            return .init(directions: side == .white ? [.east] : [.west])
        case ((-1)..., 0):
            return .init(directions: side == .white ? [.west] : [.east])
        case (0, 1...):
            return .init(directions: side == .white ? [.north] : [.south])
        case (0, (-1)...):
            return .init(directions: side == .white ? [.south] : [.north])
        default:
            return .init(directions: [])
        }
    }
    
    var type = PieceType.rook
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♖" : "♜"
    }
    var movePatterns: [MovePattern] = [
        .init(directions: [.north]),
        .init(directions: [.west]),
        .init(directions: [.east]),
        .init(directions: [.south])
    ]
    var moved = false
}

struct Knight: Piece {
    func validPattern(fileDelta: Int, rowDelta: Int, side: Side) -> MovePattern {
        switch (fileDelta, rowDelta) {
        case (-1, 2):
            return .init(directions: [.north, .north, .west])
        case (1, 2):
            return .init(directions: [.north, .north, .east])
        case (-2, 1):
            return .init(directions: [.north, .west, .west])
        case (2, 1):
            return .init(directions: [.north, .east, .east])
        case (-2, -1):
            return .init(directions: [.south, .west, .west])
        case (2, -1):
            return .init(directions: [.south, .east, .east])
        case (-1, -2):
            return .init(directions: [.south, .south, .west])
        case (1, -2):
            return .init(directions: [.south, .south, .east])
        default:
            return .init(directions: [])
        }
    }
    
    var type = PieceType.knight
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♘" : "♞"
    }
    var movePatterns: [MovePattern] = [
        .init(directions: [.north, .north, .west]),
        .init(directions: [.north, .north, .east]),
        .init(directions: [.north, .west, .west]),
        .init(directions: [.north, .east, .east]),
        .init(directions: [.south, .west, .west]),
        .init(directions: [.south, .east, .east]),
        .init(directions: [.south, .south, .west]),
        .init(directions: [.south, .south, .east])
    ]
    var moved = false
}

struct Pawn: Piece {
    func validPattern(fileDelta: Int, rowDelta: Int, side: Side) -> MovePattern {
        switch (fileDelta, rowDelta, moved, side) {
        case (0, 1...2, false, .white),
             (0, 1, true, .white):
            return .init(directions: [.north])
        case (-1, 1, _, .white):
            return .init(directions: [.northWest])
        case (1, 1, _, .white):
            return .init(directions: [.northEast])
        case (0, (-2)...(-1), false, .black),
             (0, -1, true, .black):
            return .init(directions: [.south])
        case (1, -1, _, .black):
            return .init(directions: [.southWest])
        case (-1, -1, _, .black):
            return .init(directions: [.southEast])
        default:
            return  .init(directions: [])
        }
    }
    
    var type = PieceType.pawn
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♙" : "♟"
    }
    var movePatterns: [MovePattern] = [
        .init(directions: [.north]),
        .init(directions: [.northEast]),
        .init(directions: [.northWest]),
        .init(directions: [.south]),
        .init(directions: [.southWest]),
        .init(directions: [.southEast])
    ]
    var moved = false
}
