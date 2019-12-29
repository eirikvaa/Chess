//
//  Bishop.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

struct Bishop: Piece {
    var id = UUID().uuidString
    
    func numberOfMoves(for movePattern: MovePattern) -> Int {
        movePattern.directions.count
    }
    
    func validPattern(delta: Delta, side: Side, isAttacking: Bool) -> MovePattern {
        guard delta.equalMagnitude else {
            return .init(directions: [])
        }
        
        switch (delta.x, delta.y) {
        case (1..., 1...):
            return .init(directions: .init(repeating: .northEast, count: delta.magnitude(of: \.x)))
        case (...(-1), ...(-1)):
            return .init(directions: .init(repeating: .southWest, count: delta.magnitude(of: \.x)))
        case (1..., ...(-1)):
            return .init(directions: .init(repeating: .southEast, count: delta.magnitude(of: \.x)))
        case (...(-1), 1...):
            return .init(directions: .init(repeating: .northWest, count: delta.magnitude(of: \.x)))
        default:
            return []
        }
    }
    
    var type = PieceType.bishop
    var side: Side = .white
    var graphicalRepresentation: String {
        side == .white ? "♗" : "♝"
    }
    var movePatterns: [MovePattern] = [
        [.northEast],
        [.southEast],
        [.southWest],
        [.northWest],
    ]
    var moved = false
}
