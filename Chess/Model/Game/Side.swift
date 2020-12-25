//
//  Player.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

/**
 The side of the board. A piece belongs to one or the other. Can be either white or black.
 */
enum Side: Equatable {
    case white
    case black

    /**
     Get the opposite side
     */
    var opposite: Side {
        switch self {
        case .white: return .black
        case .black: return .white
        }
    }

    static func == (lhs: Side, rhs: Side) -> Bool {
        switch (lhs, rhs) {
        case (.white, .white),
             (.black, .black):
            return true
        default:
            return false
        }
    }
}
