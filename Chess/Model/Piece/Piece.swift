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
    var whiteVersion: String { get }
    var blackVersion: String { get }
}

struct King: Piece {
    var name = "King"
    var whiteVersion = "♔"
    var blackVersion = "♚"
}

struct Queen: Piece {
    var name = "Queen"
    var whiteVersion = "♕"
    var blackVersion = "♛"
}

struct Bishop: Piece {
    var name = "Runner"
    var whiteVersion = "♗"
    var blackVersion = "♝"
}

struct Rook: Piece {
    var name = "Rook"
    var whiteVersion = "♖"
    var blackVersion = "♜"
}

struct Knight: Piece {
    var name = "Knight"
    var whiteVersion = "♘"
    var blackVersion = "♞"
}

struct Pawn: Piece {
    var name = "Pawn"
    var whiteVersion = "♙"
    var blackVersion = "♟"
}
