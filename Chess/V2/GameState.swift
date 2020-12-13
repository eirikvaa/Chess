//
//  GameState.swift
//  Chess
//
//  Created by Eirik Vale Aase on 06/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

import Foundation

/**
 Maintains the game state for a given game.
 Is responsible for always maintaing a valid game state given a move.
 It is basically a function like board(move) -> board
 */
struct GameState {
    enum GameStateError: Error {
        case illegalMove
        case noValidSourcePieces
        case ambiguousMove
        case cannotMovePieceOfOppositeSide
        case destinationIsOccupiedByOwnPiece
        case cannotPerformCaptureWithoutNotingItInMove
    }
    
    let board = Board()
    var currentSide = Side.white
    
    /**
     Execute a move and transition the game state to a new state.
     This method can throw by a variety of reasons, see `GameStateError`.
     - Parameters move: The move to execute
     */
    mutating func executeMove(move: Move) throws {
        let piece = try getSourcePiece(move: move)
        
        let sourceCell = board.getCell(of: piece)
        let destinationCell = board[move.destination]
        
        destinationCell.piece = sourceCell.piece
        sourceCell.piece = nil
        
        currentSide.toggle()
    }
}

private extension GameState {
    func getSourcePiece(move: Move) throws -> Piece {
        let possibleSourceCells = board.getAllPieces(of: move.pieceType, side: currentSide)
        
        let possibleSourcePieces: [(piece: Piece, coordinateSequence: [Coordinate], sourceCorodinate: Coordinate)] = possibleSourceCells.compactMap { cell in
            guard let piece = cell.piece else {
                return nil
            }
            
            guard piece.side == currentSide else {
                return nil
            }

            let possibleCoordinateSequences: [[Coordinate]] = piece.movePatterns.compactMap { pattern -> [Coordinate] in
                var currentCoordinate = cell.coordinate
                
                var actualDirections: [Coordinate] = []
                
                // If there is only one direction in the pattern, let's assume that the move is continuous.
                // If there are two directions, it'll be the pawn's double move.
                // If there are three directions, it'll be the knight, which we don't treat as continuous.
                let continuous = pattern.directions.count == 1 && [.queen, .rook, .bishop].contains(move.pieceType)
                
                guard continuous else {
                    fatalError("Let's try to implement the general case.")
                }
                
                guard let direction = pattern.directions.first else {
                    fatalError("GENERAL PLZ")
                }
                
                while true {
                    if let nextCoordinate = currentCoordinate.applyDirection(direction) {
                        actualDirections.append(nextCoordinate)
                        
                        if nextCoordinate == move.destination {
                            return actualDirections
                        }
                        
                        currentCoordinate = nextCoordinate
                    } else {
                        break
                    }
                }
                
                return actualDirections
            }
            
            if possibleCoordinateSequences.count > 0 {
                return (piece, possibleCoordinateSequences[0], cell.coordinate)
            }
            
            return nil
        }
        
        switch possibleSourcePieces.count {
        case 0: throw GameStateError.noValidSourcePieces
        case 1: return possibleSourcePieces[0].0
        case 2...: throw GameStateError.ambiguousMove
        default: fatalError("We only fail because the compiler don't understand that it's actually exhaustive.")
        }
    }
}
