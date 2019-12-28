//
//  Delta.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

struct Delta {
    let x: Int
    let y: Int
    
    func advance(by direction: Direction) -> Delta {
        switch direction {
        case .north:
            return .init(x: x, y: y + 1)
        case .northEast:
            return .init(x: x + 1, y: y + 1)
        case .east:
            return .init(x: x + 1, y: y)
        case .southEast:
            return .init(x: x + 1, y: y - 1)
        case .south:
            return .init(x: x, y: y - 1)
        case .southWest:
            return .init(x: x - 1, y: y - 1)
        case .west:
            return .init(x: x - 1, y: y)
        case .northWest:
            return .init(x: x - 1, y: y + 1)
        }
    }
}
