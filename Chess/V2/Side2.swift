//
//  Side2.swift
//  Chess
//
//  Created by Eirik Vale Aase on 05/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

enum Side {
    case white
    case black
    
    var opposite: Side {
        switch self {
        case .white: return .black
        case .black: return .white
        }
    }
}
