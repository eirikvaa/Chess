//
//  Piece.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

protocol Piece {
    var name: String { get }
    var player: Player? { get set }
    var graphicalRepresentation: String { get }
}

struct King: Piece {
    var name = "King"
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♔" : "♚"
    }
}

struct Queen: Piece {
    var name = "Queen"
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♕" : "♛"
    }
}

struct Bishop: Piece {
    var name = "Runner"
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♗" : "♝"
    }
}

struct Rook: Piece {
    var name = "Rook"
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♖" : "♜"
    }
}

struct Knight: Piece {
    var name = "Knight"
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♘" : "♞"
    }
}

struct Pawn: Piece {
    var name = "Pawn"
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♙" : "♟"
    }
}
