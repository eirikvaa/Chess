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
    
    func numberOfMoves(for movePattern: MovePattern) -> Int {
        movePattern.directions.count
    }
    
    func validPattern(delta: Delta, side: Side, isAttacking: Bool) -> MovePattern {
        switch (delta.x, delta.y) {
        case (1..., 0):
            let direction = Direction.east.sideRelativeDirection(side)
            return .init(directions: .init(repeating: direction, count: delta.magnitude(of: \.x)))
        case (...(-1), 0):
            let direction = Direction.west.sideRelativeDirection(side)
            return .init(directions: .init(repeating: direction, count: delta.magnitude(of: \.x)))
        case (0, 1...):
            let direction = Direction.north.sideRelativeDirection(side)
            return .init(directions: .init(repeating: direction, count: delta.magnitude(of: \.y)))
        case (0, ...(-2)):
            let direction = Direction.south.sideRelativeDirection(side)
            return .init(directions: .init(repeating: direction, count: delta.magnitude(of: \.y)))
        default:
            return []
        }
    }
    
    var type = PieceType.rook
    var side: Side = .white
    var graphicalRepresentation: String {
        side == .white ? "♖" : "♜"
    }
    var movePatterns: [MovePattern] = [
        [.north],
        [.west],
        [.east],
        [.south]
    ]
    var moved = false
}
