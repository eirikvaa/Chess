//
//  Delta.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

struct Delta {
    let x: Int
    let y: Int

    var toDirection: Direction {
        switch (x, y) {
        case (1, 0): return .east
        case (-1, 0): return .west
        case (0, 1): return .north
        case (0, -1): return .south
        case (1, 1): return .northEast
        case (1, -1): return .southEast
        case (-1, 1): return .northWest
        case (-1, -1): return .southWest
        default: fatalError("\((x, y)) is an invalid delta.")
        }
    }

    func advance(by direction: Direction) -> Delta {
        switch direction {
        case .north:
            return .init(x: x, y: y + 1)
        case .northEast:
            return .init(x: x + 1, y: y + 1)
        case .east:
            return .init(x: x + 1, y: y)
        case .southEast:
            return .init(x: x + 1, y: y - 1)
        case .south:
            return .init(x: x, y: y - 1)
        case .southWest:
            return .init(x: x - 1, y: y - 1)
        case .west:
            return .init(x: x - 1, y: y)
        case .northWest:
            return .init(x: x - 1, y: y + 1)
        }
    }

    var equalMagnitude: Bool {
        abs(x) == abs(y)
    }

    /// Finds the maximum magnitude of either direction.
    /// Helpful when finding the number of steps when the rook moves.
    var maximumMagnitude: Int {
        abs(max(x, y))
    }

    func magnitude(of keyPath: KeyPath<Delta, Int>) -> Int {
        return abs(self[keyPath: keyPath])
    }

    static func * (lhs: Delta, rhs: Int) -> Delta {
        .init(x: lhs.x * rhs, y: lhs.y * rhs)
    }
}
