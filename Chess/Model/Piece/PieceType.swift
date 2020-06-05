//
//  PieceType.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

enum PieceType {
    case king
    case queen
    case bishop
    case knight
    case rook
    case pawn
}

struct PieceTypeFabric {
    static func create(_ character: Character) -> PieceType {
        switch character {
        case "K": return .king
        case "Q": return .queen
        case "B": return .bishop
        case "N": return .knight
        case "R": return .rook
        default: return .pawn
        }
    }
}
