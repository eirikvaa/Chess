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
enum Side {
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
}
