//
//  Direction.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
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
        case .north: "N"
        case .northWest: "NW"
        case .northEast: "NE"
        case .east: "E"
        case .south: "S"
        case .southWest: "SW"
        case .southEast: "SE"
        case .west: "W"
        }
    }
}
