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
    private var prePlayedMoves = [Move]()
}

extension Game {
    init(prePlayedMoves: [Move]) {
        self.prePlayedMoves.append(contentsOf: prePlayedMoves)
    }
}

extension Game {
    mutating func startGame(continueAfterPrePlayedMoves: Bool = true) throws {
        resetBoard()
        
        var currentPlayer = whitePlayer
        var round = 0
        
        for move in prePlayedMoves {
            printBoard()
            
            do {
                try performMoveHandleError(move: move, currentPlayer: &currentPlayer)
            } catch {
                // If something went wrong when adding the preplayed moves, we did something
                // wrong and should just quit.
                throw error
            }
            
            finishRound(round: &round, currentPlayer: &currentPlayer)
        }
        
        guard continueAfterPrePlayedMoves else {
            printBoard()
            return
        }
        
        while true {
            printBoard()
            
            print("\(currentPlayer.name), please input a move:")
            let input = readLine(strippingNewline: true)
            
            guard input != "quit" else {
                print("Quitting ...")
                break
            }
            
            guard let move = try? Move(move: input ?? "") else {
                print("Move not on correct format, try again.")
                continue
            }
            
            do {
                try performMoveHandleError(move: move, currentPlayer: &currentPlayer)
            } catch {
                // If something went wrong during playing, we did something wrong, but don't
                // want to play from the start, so just try again.
                continue
            }
            
            finishRound(round: &round, currentPlayer: &currentPlayer)
        }
    }
    
    mutating func performMoveHandleError(move: Move, currentPlayer: inout Player) throws {
        var sourcePiece = board[move.sourceCoordinate]
        let destinationPiece = board[move.destinationCoordinate]
        
        do {
            try validateMove(move: move, sourcePiece: sourcePiece, destinationPiece: destinationPiece, currentPlayer: &currentPlayer)
        } catch let gameError as GameError {
            printErrorMessage(gameError: gameError)
            throw gameError
        } catch {
            print("Something went wrong")
            throw error
        }
        
        sourcePiece?.moved = true
        board[move.destinationCoordinate] = sourcePiece
        board[move.sourceCoordinate] = nil
    }
    
    mutating func validateMove(move: Move, sourcePiece: Piece?, destinationPiece: Piece?, currentPlayer: inout Player) throws {
       guard let sourcePiece = sourcePiece else {
           throw GameError.noPieceInSourcePosition
       }
       
       guard sourcePiece.player?.side == currentPlayer.side else {
           throw GameError.invalidPiece
       }
       
       guard try validateMovePattern(move: move, sourcePiece: sourcePiece, destinationPiece: destinationPiece, currentPlayer: currentPlayer) else {
           throw GameError.invalidMove(message: "Invalid move pattern!")
       }
       
        currentPlayer.addMove(move)
    }
    
    func validateMovePattern(move: Move, sourcePiece: Piece, destinationPiece: Piece?, currentPlayer: Player) throws -> Bool {
        var sourceCoordinate = move.sourceCoordinate
        let destinationCoordinate = move.destinationCoordinate
        
        let moveDelta = sourceCoordinate.difference(from: destinationCoordinate)

        let fileDelta = destinationCoordinate.fileIndex - sourceCoordinate.fileIndex
        let rowDelta = destinationCoordinate.row - sourceCoordinate.row
        
        let validPattern = sourcePiece.validPattern(delta: moveDelta, side: currentPlayer.side)
        
        guard validPattern.directions.count > 0 else {
            throw GameError.invalidMove(message: "No valid directions to destination position")
        }
        
        for direction in validPattern.directions {
            switch (direction, sourcePiece.type) {
            case (.north, .pawn),
                 (.south, .pawn):
                guard destinationPiece == nil else {
                    throw GameError.invalidMove(message: "Destination position occupied")
                }
            case (.northEast, .pawn),
                 (.northWest, .pawn):
                guard destinationPiece != nil else {
                    throw GameError.invalidMove(message: "Attack requires opponent piece in destination position")
                }
            case (.north, .rook),
                 (.east, .rook),
                 (.west, .rook),
                 (.south, .rook):
                let side = currentPlayer.side
                let numberOfMoves = fileDelta == 0 ? abs(rowDelta) : abs(fileDelta)
                
                var currentCoordinate = sourceCoordinate
                for _ in 1 ... numberOfMoves {
                    currentCoordinate = currentCoordinate.move(by: direction, side: side)
                    
                    if currentCoordinate == destinationCoordinate {
                        break
                    }
                    
                    if board[currentCoordinate] != nil  {
                        throw GameError.invalidMove(message: "Cannot move over opposite piece")
                    }
                }
                
                if board[destinationCoordinate, currentPlayer.side] {
                    throw GameError.invalidMove(message: "Cannot move to position occupied by self")
                }
            case (_, .king),
                 (_, .queen):
                if board[move.destinationCoordinate, currentPlayer.side] {
                    throw GameError.invalidMove(message: "Trying to move to position occupied by own piece.")
                }
            case (.northWest, .bishop),
                 (.southWest, .bishop),
                 (.northEast, .bishop),
                 (.southEast, .bishop):
                let numberOfMoves = abs(fileDelta)
                for _ in 0 ..< numberOfMoves {
                    let newCoordinate = sourceCoordinate.move(by: direction, side: currentPlayer.side)
                    
                    if board[newCoordinate, currentPlayer.side] {
                        throw GameError.invalidMove(message: "Trying to move to or over own piece.")
                    }
                }
            case (_, .knight):
                let validAttack = destinationPiece != nil && destinationPiece?.player?.side != currentPlayer.side
                let validMove = destinationPiece == nil
                
                guard validAttack || validMove else {
                    throw GameError.invalidMove(message: "Must either be a valid attack or valid move.")
                }
            default:
                break
            }
        }
        
        return true
    }
    
    mutating func finishRound(round: inout Int, currentPlayer: inout Player) {
        round += 1
        currentPlayer = round.isMultiple(of: 2) ? whitePlayer : blackPlayer
    }
    
    func printErrorMessage(gameError: GameError) {
        switch gameError {
        case .invalidPiece:
            print("You cannot use the piece of an opponent.")
        case .ownPieceInDestinationPosition:
            print("You cannot move a piece to a position taken up by your own pieces.")
        case .invalidMove(let message):
            print(message)
        case .noPieceInSourcePosition:
            print("There is no piece in the source position you entered.")
        case .invalidMoveFormat:
            print("Move was on an invalid format.")
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
        
        for (index, file) in File.validFiles.enumerated() {
            board[BoardCoordinate(file: file, row: 8)] = blackRow1[index]
            board[BoardCoordinate(file: file, row: 7)] = blackRow2[index]
            
            board[BoardCoordinate(file: file, row: 2)] = whiteRow2[index]
            board[BoardCoordinate(file: file, row: 1)] = whiteRow1[index]
        }
    }
}