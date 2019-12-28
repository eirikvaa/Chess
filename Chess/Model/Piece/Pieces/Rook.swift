//
//  Rook.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

struct Rook: Piece {
    func validPattern(fileDelta: Int, rowDelta: Int, side: Side) -> MovePattern {
        switch (fileDelta, rowDelta) {
        case (1..., 0):
            return side == .white ? [.east] : [.west]
        case (...(-1), 0):
            return side == .white ? [.west] : [.east]
        case (0, 1...):
            return side == .white ? [.north] : [.south]
        case (0, ...(-2)):
            return side == .white ? [.south] : [.north]
        default:
            return []
        }
    }
    
    var type = PieceType.rook
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♖" : "♜"
    }
    var movePatterns: [MovePattern] = [
        [.north],
        [.west],
        [.east],
        [.south]
    ]
    var moved = false
}
