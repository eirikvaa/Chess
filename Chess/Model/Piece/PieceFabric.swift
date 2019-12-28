//
//  PieceFabric.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

struct PieceFabric {
    static func create(_ type: PieceType) -> Piece {
        switch type {
        case .king: return King()
        case .queen: return Queen()
        case .bishop: return Bishop()
        case .knight: return Knight()
        case .rook: return Rook()
        case .pawn: return Pawn()
        }
    }
}
