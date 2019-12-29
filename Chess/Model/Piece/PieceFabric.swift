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
    
    static func create(_ character: Character?) -> Piece {
        guard let character = character else {
            return create(.pawn)
        }
        
        switch String(character) {
        case "K": return create(.king)
        case "Q": return create(.queen)
        case "N": return create(.knight)
        case "R": return create(.rook)
        default: return create(.pawn)
        }
    }
}
