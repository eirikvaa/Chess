//
//  BoardCell.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

struct BoardCell {
    let coordinate: BoardCoordinate
    var piece: Piece?
}

extension BoardCell: CustomStringConvertible {
    var description: String {
        return piece?.graphicalRepresentation ?? " "
    }
}
