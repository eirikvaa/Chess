//
//  PieceType2.swift
//  Chess
//
//  Created by Eirik Vale Aase on 05/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

enum PieceType {
    case pawn
    case bishop
    case knight
    case rook
    case queen
    case king
    
    init(rawPiece: String) {
        switch rawPiece {
        case "B": self = .bishop
        case "N": self = .knight
        case "R": self = .rook
        case "Q": self = .queen
        case "K": self = .king
        default: self = .pawn
        }
    }
}

protocol Piece: AnyObject {
    var content: String { get }
    var type: PieceType { get }
    var side: Side { get set }
    
    init(side: Side)
}

class Rook: Piece {
    var content: String {
        side == .white ? "♖" : "♜"
    }
    var type: PieceType = .rook
    var side: Side = .white
    
    required init(side: Side) {
        self.side = side
    }
}

class Bishop: Piece {
    var content: String {
        side == .white ? "♗" : "♝"
    }
    var type: PieceType = .bishop
    var side: Side = .white
    
    required init(side: Side) {
        self.side = side
    }
}

class Knight: Piece {
    var content: String {
        side == .white ? "♘" : "♞"
    }
    var type: PieceType = .knight
    var side: Side = .white
    
    required init(side: Side) {
        self.side = side
    }
}

class Pawn: Piece {
    var content: String {
        side == .white ? "♙" : "♟"
    }
    var type: PieceType = .pawn
    var side: Side = .white
    
    required init(side: Side) {
        self.side = side
    }
}

class Queen: Piece {
    var content: String {
        side == .white ? "♕" : "♛"
    }
    var type: PieceType = .queen
    var side: Side = .white
    
    required init(side: Side) {
        self.side = side
    }
}

class King: Piece {
    var content: String {
        side == .white ? "♔" : "♚"
    }
    var type: PieceType = .king
    var side: Side = .white
    
    required init(side: Side) {
        self.side = side
    }
}
