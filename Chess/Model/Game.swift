//
//  Game.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

enum GameErrors: Error {
    case invalidMoveFormat
    case noPieceInSourcePosition
    case ownPieceInDestinationPosition
    case invalidPiece
}

struct Game {
    private var board = Board()
    let whitePlayer = Player(side: .white)
    let blackPlayer = Player(side: .black)
}

extension Game {
    mutating func startGame() {
        resetBoard()
        
        var currentPlayer = whitePlayer
        var round = 0
        
        while true {
            printBoard()
            
            print("\(currentPlayer.name), please input a move:")
            let input = readLine(strippingNewline: true)
            
            guard let move = try? Move(move: input ?? "") else {
                print("Move not on correct format, try again.")
                continue
            }
            
            guard move.text != "quit" else {
                print("You quit")
                break
            }
            
            let sourcePiece = board[move.source]
            let destinationPiece = board[move.destination]
            
            do {
                try currentPlayer.makeMove(
                    move.text,
                    sourcePiece: sourcePiece,
                    destinationPiece: destinationPiece)
            } catch GameErrors.noPieceInSourcePosition {
                print("There is no piece in the source position you entered.")
                continue
            } catch GameErrors.invalidPiece {
                print("You cannot use the piece of an opponent.")
                continue
            } catch GameErrors.ownPieceInDestinationPosition {
                print("You cannot move a piece to a position taken up by your own pieces.")
                continue
            } catch {
                print("Something went wrong, try again.")
                continue
            }
            
            print("\(currentPlayer.name) performed the following move: \(move.text)")
            
            round += 1
            currentPlayer = round.isMultiple(of: 2) ? whitePlayer : blackPlayer
        }
    }
    
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
        
        for (index, file) in board.validFiles.enumerated() {
            board[file, 0] = blackRow1[index]
            board[file, 1] = blackRow2[index]
            
            board[file, 6] = whiteRow2[index]
            board[file, 7] = whiteRow1[index]
        }
    }
}
