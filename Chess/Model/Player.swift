//
//  Player.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

struct Player {
    enum Side {
        case white
        case black
    }
    
    let side: Side
    private var moves: [String] = []
    
    init(side: Side) {
        self.side = side
    }
    
    mutating func makeMove(_ move: String, sourcePiece: Piece?, destinationPiece: Piece?) throws {
        guard let sourcePiece = sourcePiece else {
            throw GameErrors.noPieceInSourcePosition
        }
        
        guard sourcePiece.player?.side == self.side else {
            throw GameErrors.invalidPiece
        }
        
        if destinationPiece?.player?.side == self.side {
            throw GameErrors.ownPieceInDestinationPosition
        }
        
        // TODO: Make sure move is valid
        
        moves.append(move)
    }
    
    var name: String {
        return side == .white ? "White player" : "Black player"
    }
}
