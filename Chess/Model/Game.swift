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
    case invalidMove(message: String)
}

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
            return
        }
        
        while true && !continueAfterPrePlayedMoves {
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
    
    mutating func finishRound(round: inout Int, currentPlayer: inout Player) {
        round += 1
        currentPlayer = round.isMultiple(of: 2) ? whitePlayer : blackPlayer
    }
    
    mutating func performMoveHandleError(move: Move, currentPlayer: inout Player) throws {
        var sourcePiece = board[move.source]
        let destinationPiece = board[move.destination]
        
        do {
            try validateMove(move: move, sourcePiece: sourcePiece, destinationPiece: destinationPiece, currentPlayer: &currentPlayer)
        } catch let gameError as GameErrors {
            printErrorMessage(gameError: gameError)
            throw gameError
        } catch {
            print("Something went wrong")
            throw error
        }
        
        sourcePiece?.moved = true
        board[move.destination] = sourcePiece
        board[move.source] = nil
    }
    
    func printErrorMessage(gameError: GameErrors) {
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
    
    func distanceBetweenFiles(sourceFile: String, destinationFile: String) -> Int {
        func fileToIndex(_ file: String) -> Int {
            let files = ["a", "b", "c", "d", "e", "f", "g", "h"]
            return files.firstIndex(of: file.lowercased()) ?? 0
        }
        
        let sourceFileIndex = fileToIndex(sourceFile)
        let destinationFileIndex = fileToIndex(destinationFile)
        
        return destinationFileIndex - sourceFileIndex
    }
    
    func validateMovePattern(move: Move, sourcePiece: Piece, destinationPiece: Piece?, currentPlayer: Player) throws -> Bool {
        // Multiply with -1 if we are black as north will be opposite way for them
        let sideMultiplier = currentPlayer.side.sideMultiplier
        
        let (sourceFile, sourceRow) = move.partition(moveComponent: move.source)
        let (destinationFile, destinationRow) = move.partition(moveComponent: move.destination)
        let sourceFileIndex = board.fileToIndex(sourceFile)
        let destinationFileIndex = board.fileToIndex(destinationFile)
        
        let fileDelta = distanceBetweenFiles(sourceFile: sourceFile, destinationFile: destinationFile)
        let rowDelta = (destinationRow - sourceRow) * sideMultiplier
        
        let validPattern = sourcePiece.validPattern(
            move: move,
            fileDelta: fileDelta,
            rowDelta: rowDelta,
            side: currentPlayer.side)
        
        guard validPattern.directions.count > 0 else {
            throw GameErrors.invalidMove(message: "No valid directions to destination position")
        }
        
        for direction in validPattern.directions {
            switch (direction, sourcePiece.type) {
            case (.north, .pawn):
                guard destinationPiece == nil else {
                    throw GameErrors.invalidMove(message: "Destination position occupied")
                }
            case (.northEast, .pawn),
                 (.northWest, .pawn):
                guard destinationPiece != nil else {
                    throw GameErrors.invalidMove(message: "Attack requires opponent piece in destination position")
                }
            case (.north, .rook),
                 (.east, .rook),
                 (.west, .rook),
                 (.south, .rook):
                if fileDelta == 0 {
                    for i in 1 ... rowDelta {
                        let newRow = sourceRow + i * sideMultiplier
                        if board["\(sourceFile)\(newRow)", currentPlayer.side] {
                            throw GameErrors.invalidMove(message: "Trying to move to or over own piece.")
                        }
                    }
                } else if rowDelta == 0 {
                    for i in 1 ... fileDelta {
                        let newFile = board.fileIndexToFile(sourceFileIndex + i * sideMultiplier)
                        if board["\(newFile)\(sourceRow)", currentPlayer.side] {
                            throw GameErrors.invalidMove(message: "Trying to move to or over own piece.")
                        }
                    }
                }
            case (_, .king),
                 (_, .queen):
                if board[move.destination, currentPlayer.side] {
                    throw GameErrors.invalidMove(message: "Trying to move to position occupied by own piece.")
                }
            case (.northWest, .bishop),
                 (.southWest, .bishop):
                let source = sourceFileIndex + 1 * sideMultiplier
                let dest = destinationFileIndex
                let fileRange = min(source, dest) ... max(source, dest)
                let rowRange = (sourceRow + 1 * sideMultiplier) ... (destinationRow)
                for (i, j) in zip(fileRange, rowRange.reversed()) {
                    let newFile = board.fileIndexToFile(i)
                    //let newRow = sourceRow + j * sideMultiplier
                    let newFileRowString = "\(newFile)\(j)"
                    
                    if board[newFileRowString, currentPlayer.side] {
                        throw GameErrors.invalidMove(message: "Trying to move to or over own piece.")
                    }
                }
                case (.northEast, .bishop),
                     (.southEast, .bishop):
                let source = sourceFileIndex + 1 * sideMultiplier
                let dest = destinationFileIndex
                let fileRange = min(source, dest) ... max(source, dest)
                let rowRange = (sourceRow + 1 * sideMultiplier) ... (destinationRow)
                for (i, j) in zip(fileRange, rowRange) {
                    print(i, j)
                    let newFile = board.fileIndexToFile(i)
                    //let newRow = sourceRow + j * sideMultiplier
                    let newFileRowString = "\(newFile)\(j)"
                    
                    if board[newFileRowString, currentPlayer.side] {
                        throw GameErrors.invalidMove(message: "Trying to move to or over own piece.")
                    }
                }
            default:
                break
            }
        }
        
        return true
    }
    
    func printBoard() {
        print(board)
    }
    
    mutating func validateMove(move: Move, sourcePiece: Piece?, destinationPiece: Piece?, currentPlayer: inout Player) throws {
       guard let sourcePiece = sourcePiece else {
           throw GameErrors.noPieceInSourcePosition
       }
       
       guard sourcePiece.player?.side == currentPlayer.side else {
           throw GameErrors.invalidPiece
       }
       
       if destinationPiece?.player?.side == currentPlayer.side {
           throw GameErrors.ownPieceInDestinationPosition
       }
       
       guard try validateMovePattern(move: move, sourcePiece: sourcePiece, destinationPiece: destinationPiece, currentPlayer: currentPlayer) else {
           throw GameErrors.invalidMove(message: "Invalid move pattern!")
       }
       
        currentPlayer.addMove(move)
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
