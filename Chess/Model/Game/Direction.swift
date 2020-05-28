//
//  Direction.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

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

    func relativeDelta(for side: Side) -> Delta {
        let delta: Delta

        switch self {
        case .north:
            delta = .init(x: 0, y: 1)
        case .northWest:
            delta = .init(x: -1, y: 1)
        case .northEast:
            delta = .init(x: 1, y: 1)
        case .south:
            delta = .init(x: 0, y: -1)
        case .southWest:
            delta = .init(x: -1, y: -1)
        case .southEast:
            delta = .init(x: 1, y: -1)
        case .west:
            delta = .init(x: -1, y: 0)
        case .east:
            delta = .init(x: 1, y: 0)
        }

        return delta * side.sideMultiplier
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
