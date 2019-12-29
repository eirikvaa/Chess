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
    
    func validPattern(delta: Delta, side: Side) -> MovePattern {
        guard delta.equalMagnitude else {
            return .init(directions: [])
        }
        
        switch (delta.x, delta.y) {
        case (1..., 1...):
            let direction = Direction.northEast.sideRelativeDirection(side)
            return .init(directions: .init(repeating: direction, count: delta.magnitude(of: \.x)))
        case (...(-1), ...(-1)):
            let direction = Direction.southWest.sideRelativeDirection(side)
            return .init(directions: .init(repeating: direction, count: delta.magnitude(of: \.x)))
        case (1..., ...(-1)):
            let direction = Direction.southEast.sideRelativeDirection(side)
            return .init(directions: .init(repeating: direction, count: delta.magnitude(of: \.x)))
        case (...(-1), 1...):
            let direction = Direction.northWest.sideRelativeDirection(side)
            return .init(directions: .init(repeating: direction, count: delta.magnitude(of: \.x)))
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
