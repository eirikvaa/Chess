//
//  Game.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

struct Game {
    private var board = Board()
    let whitePlayer = Player(side: .white)
    let blackPlayer = Player(side: .black)
}

extension Game {
    func printBoard() {
        print(board)
    }
    
    mutating func resetBoard() {
        func assignPieceToPlayer(piece: inout Piece, player: Player) {
            piece.player = player
        }
        
        var whiteRow1: [Piece] = [Rook(), Knight(), Bishop(), Queen(), King(), Bishop(), Knight(), Rook()]
        var whiteRow2: [Piece] = Array(repeating: Pawn(), count: 8)
        
        var blackRow1: [Piece] = [Rook(), Knight(), Bishop(), Queen(), King(), Bishop(), Knight(), Rook()]
        var blackRow2: [Piece] = Array(repeating: Pawn(), count: 8)
        
        for i in 0 ..< whiteRow1.count {
            assignPieceToPlayer(piece: &whiteRow1[i], player: whitePlayer)
            assignPieceToPlayer(piece: &whiteRow2[i], player: whitePlayer)
            assignPieceToPlayer(piece: &blackRow1[i], player: blackPlayer)
            assignPieceToPlayer(piece: &blackRow2[i], player: blackPlayer)
        }
        
        for (index, column) in board.validColumns.enumerated() {
            board[0, column] = blackRow1[index]
            board[7, column] = whiteRow1[index]
        }
        
        for (index, column) in board.validColumns.enumerated() {
            board[1, column] = blackRow2[index]
            board[6, column] = whiteRow2[index]
        }
    }
}
