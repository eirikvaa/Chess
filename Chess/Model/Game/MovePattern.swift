//
//  MovePattern.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

// TODO: Experiment with this instead of the current types
enum MoveP {
    case single(Direction)
    case double(Direction, Direction)
    case shape(Direction, Direction, Direction)
    case diagonal(Direction)
    case continuous(Direction)
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

    static func == (lhs: MovePattern, rhs: MovePattern) -> Bool {
        guard lhs.moveType == rhs.moveType else {
            return false
        }

        for (lhsDirection, rhsDirection) in zip(lhs.directions, rhs.directions) where lhsDirection != rhsDirection {
            return false
        }

        return true
    }
}
