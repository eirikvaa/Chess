//
//  Player.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

enum Side {
    case white
    case black
    
    var sideMultiplier: Int {
        return self == .black ? -1 : 1
    }
    
    var oppositeSide: Side {
        switch self {
        case .black: return .white
        case .white: return .black
        }
    }
}

struct Player {
    let side: Side
    private var moves: [Move] = []
    
    init(side: Side) {
        self.side = side
    }
    
    var name: String {
        return side == .white ? "White player" : "Black player"
    }
    
    mutating func addMove(_ move: Move) {
        moves.append(move)
    }
}
