//
//  Direction.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

/// Directions as seen from the perspective of the white player (towards the black player).
/// Avoid adding north-west, et cetera, as those can be composed from these four.
enum Direction: CustomStringConvertible {
    case north
    case northWest
    case northEast
    case east
    case south
    case southWest
    case southEast
    case west

    var description: String {
        switch self {
        case .north: return "N"
        case .northWest: return "NW"
        case .northEast: return "NE"
        case .east: return "E"
        case .south: return "S"
        case .southWest: return "SW"
        case .southEast: return "SE"
        case .west: return "W"
        }
    }
}
