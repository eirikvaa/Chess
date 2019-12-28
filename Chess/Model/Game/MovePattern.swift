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
        self.directions = elements
    }
}

extension MovePattern: Equatable {
    static func == (lhs: MovePattern, rhs: MovePattern) -> Bool {
        lhs.directions == rhs.directions
    }
}

extension MovePattern: CustomStringConvertible {
    var description: String {
        guard directions.count > 0 else {
            return "[]"
        }
        
        guard directions.count > 1 else {
            return "\(directions[0])"
        }
        
        var _description = "["
        
        for pattern in directions {
            _description += "\(pattern.description)\t→\t"
        }
        
        _description += "]"
        
        return _description
    }
}
