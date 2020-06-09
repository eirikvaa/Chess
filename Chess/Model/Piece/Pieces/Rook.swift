//
//  Rook.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

struct Rook: Piece {
    var id = UUID().uuidString
    var side: Side = .white
    var type = PieceType.rook
    var moved = false
    var graphicalRepresentation: String {
        side == .white ? "♜" : "♖"
    }
    var validPatterns: [MovePattern] {
        [
            .eight(.north),
            .eight(.east),
            .eight(.south),
            .eight(.west)
        ]
    }

    func validPattern(source: BoardCoordinate, destination: BoardCoordinate) -> MovePattern {
        let delta = destination - source
        
        switch (delta.x, delta.y) {
        case (1..., 0):
            let direction = Direction.east
            return .init(directions: .init(repeating: direction, count: delta.magnitude(of: \.x)))
        case ((-8)...(-1), 0):
            let direction = Direction.west
            return .init(directions: .init(repeating: direction, count: delta.magnitude(of: \.x)))
        case (0, 1...):
            let direction = Direction.north
            return .init(directions: .init(repeating: direction, count: delta.magnitude(of: \.y)))
        case (0, (-8)...(-1)):
            let direction = Direction.south
            return .init(directions: .init(repeating: direction, count: delta.magnitude(of: \.y)))
        default:
            return []
        }
    }
}
