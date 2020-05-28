//
//  MovePattern.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

struct MovePattern {
    let directions: [Direction]
}

extension MovePattern: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Direction...) {
        directions = elements
    }
}

extension MovePattern: Equatable {
    static func == (lhs: MovePattern, rhs: MovePattern) -> Bool {
        lhs.directions == rhs.directions
    }
}
