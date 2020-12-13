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
     Mutate the side by setting it to the opposite side.
     */
    mutating func toggle() {
        switch self {
        case .white: self = .black
        case .black: self = .white
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
