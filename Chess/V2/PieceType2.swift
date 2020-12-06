//
//  PieceType2.swift
//  Chess
//
//  Created by Eirik Vale Aase on 05/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

enum PieceType2 {
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

protocol Piece2: AnyObject {
    var content: String { get }
    var type: PieceType2 { get }
    var side: Side2 { get set }
    
    init(side: Side2)
}

class Rook2: Piece2 {
    var content: String {
        side == .white ? "♖" : "♜"
    }
    var type: PieceType2 = .rook
    var side: Side2 = .white
    
    required init(side: Side2) {
        self.side = side
    }
}

class Bishop2: Piece2 {
    var content: String {
        side == .white ? "♗" : "♝"
    }
    var type: PieceType2 = .bishop
    var side: Side2 = .white
    
    required init(side: Side2) {
        self.side = side
    }
}

class Knight2: Piece2 {
    var content: String {
        side == .white ? "♘" : "♞"
    }
    var type: PieceType2 = .knight
    var side: Side2 = .white
    
    required init(side: Side2) {
        self.side = side
    }
}

class Pawn2: Piece2 {
    var content: String {
        side == .white ? "♙" : "♟"
    }
    var type: PieceType2 = .pawn
    var side: Side2 = .white
    
    required init(side: Side2) {
        self.side = side
    }
}

class Queen2: Piece2 {
    var content: String {
        side == .white ? "♕" : "♛"
    }
    var type: PieceType2 = .queen
    var side: Side2 = .white
    
    required init(side: Side2) {
        self.side = side
    }
}

class King2: Piece2 {
    var content: String {
        side == .white ? "♔" : "♚"
    }
    var type: PieceType2 = .king
    var side: Side2 = .white
    
    required init(side: Side2) {
        self.side = side
    }
}
