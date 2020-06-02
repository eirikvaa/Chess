//
//  Rank.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

struct Rank: ExpressibleByIntegerLiteral, Equatable, CustomStringConvertible {
    var rank = 1
    
    static var validRanks = 1 ... 8
    
    init(integerLiteral value: Int) {
        self.rank = value
    }
    
    static func +(lhs: Rank, rhs: Int) -> Rank {
        // TODO: Add error handling
        .init(integerLiteral: lhs.rank + rhs)
    }
    
    static func ==(lhs: Rank, rhs: Rank) -> Bool {
        lhs.rank == rhs.rank
    }
    
    static func - (lhs: Rank, rhs: Rank) -> Rank {
        .init(integerLiteral: rhs.rank - lhs.rank)
    }
    
    var description: String {
        String(rank)
    }
}
