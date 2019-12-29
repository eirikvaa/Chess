//
//  Rank.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

/// Ranks are rows numbered from 1 to 8 from the perspective of each side.
typealias Rank = Int

extension Rank {
    static var validRanks = 1 ... 8
}
