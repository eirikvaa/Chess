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

extension MovePattern: CustomStringConvertible {
    var description: String {
        String(describing: directions)
    }
}

extension MovePattern: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Direction...) {
        directions = elements
    }
    
    static func + (lhs: MovePattern, rhs: MovePattern) -> MovePattern {
        .init(directions: lhs.directions + rhs.directions)
    }
}

extension MovePattern: Equatable {
    static func == (lhs: MovePattern, rhs: MovePattern) -> Bool {
        lhs.directions == rhs.directions
    }
}
