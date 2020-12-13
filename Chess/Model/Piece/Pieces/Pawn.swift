//
//  Pawn.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

extension MovePattern {
    static func n(_ direction: Direction, count: Int) -> MovePattern {
        .init(directions: Array(repeating: direction, count: count))
    }

    static func one(_ direction: Direction) -> MovePattern {
        n(direction, count: 1)
    }

    static func two(_ direction: Direction) -> MovePattern {
        n(direction, count: 2)
    }

    static func eight(_ direction: Direction) -> MovePattern {
        n(direction, count: 8)
    }
}

struct Pawn: Piece, Identifiable {
    var id = UUID()
    var side: Side = .white
    var type = PieceType.pawn
    var moved = false
    var graphicalRepresentation: String {
        side == .white ? "♟" : "♙"
    }
    var validPatterns: [MovePattern] {
        switch (side, moved) {
        case (.white, false): return [[.north], [.north, .north], [.northWest], [.northEast]]
        case (.white, true): return [[.north], [.northWest], [.northEast]]
        case (.black, false): return [[.south], [.south, .south], [.southWest], [.southEast]]
        case (.black, true): return [[.south], [.southWest], [.southEast]]
        }
    }

    func validPattern(source: BoardCoordinate, destination: BoardCoordinate) -> MovePattern {
        let delta = destination - source

        switch (delta.x, delta.y) {
        case (0, 1...2): return MovePattern(directions: Array(repeating: Direction.north, count: delta.y))
        case (0, (-2)...(-1)): return MovePattern(directions: Array(repeating: Direction.south, count: abs(delta.y)))
        case (1, 1): return [.northEast]
        case (-1, 1): return [.northWest]
        case (1, -1): return [.southEast]
        case (-1, -1): return [.southWest]
        default: return []
        }
    }
}
