//
//  Rank.swift
//  Chess
//
//  Created by Eirik Vale Aase on 06/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

import Foundation

/**
 A rank is a row as seen from white's perspective.
 Goes from 1 to 8 from nearest to farthest.
 */
struct Rank: Equatable, CustomStringConvertible, ExpressibleByIntegerLiteral {
    let value: Int
    
    init(integerLiteral value: Int) {
        self.value = value
    }
    
    init(value: Int) {
        self.value = value
    }
    
    static func == (lhs: Rank, rhs: Rank) -> Bool {
        lhs.value == rhs.value
    }
    
    static func + (lhs: Rank, rhs: Direction) -> Rank? {
        let deltaY: Int
        switch rhs {
        case .north,
             .northWest,
             .northEast: deltaY = 1
        case .south,
             .southWest,
             .southEast: deltaY = -1
        default: deltaY = 0
        }
        
        let newIndex = lhs.value + deltaY
        
        guard 1...8 ~= newIndex else {
            return nil
        }
        
        return Rank(value: newIndex)
    }
    
    static var validRanks = 1...8
    
    var description: String {
        "\(value)"
    }
}
