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

    var oppositeSide: Side {
        switch self {
        case .black: return .white
        case .white: return .black
        }
    }

    var name: String {
        switch self {
        case .white: return "White player"
        case .black: return "Black player"
        }
    }
}
