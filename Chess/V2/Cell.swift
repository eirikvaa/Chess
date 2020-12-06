//
//  Cell.swift
//  Chess
//
//  Created by Eirik Vale Aase on 06/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

import Foundation

struct Cell: CustomStringConvertible {
    var coordinate: Coordinate
    var piece: Piece?
    
    var description: String {
        // TODO: Print piece also
        String(describing: coordinate)
    }
}
