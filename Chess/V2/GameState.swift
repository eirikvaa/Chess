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
        // If the source coordinate is provided in the raw move, immediately return the corresponding piece
        if let sourceCoordinate = move.source, let piece = board[sourceCoordinate].piece {
            if piece.side != currentSide {
                throw GameStateError.cannotMovePieceOfOppositeSide
            } else {
                return piece
            }
        }
        
        let possibleSourceCells = board.getAllPieces(of: move.pieceType, side: currentSide)
        var sourcePieces: [Piece] = []
        
        for cell in possibleSourceCells {
            guard let piece = cell.piece else {
                continue
            }
            
            guard piece.side == currentSide else {
                continue
            }
            
            // Filter out all illegal move patterns
            let movePatterns = piece.movePatterns.filter { movePattern in
                guard let _ = cell.coordinate.getMovePattern(to: move.destination, with: movePattern.moveType)?.directions else {
                    return false
                }
                
                switch move.pieceType {
                case .pawn:
                    // For now, only allow a pawn to move diagonally if it's attacking a piece of the opposite side
                    // This disallows en passant, and it also probably allows
                    if move.isCapture && movePattern.moveType == .diagonal && board[move.destination].piece?.side != currentSide {
                        return true
                    } else {
                        if movePattern.moveType == .diagonal {
                            return false
                        }
                    }
                default: break
                }
                
                return true
            }
            
            if movePatterns.isEmpty {
                continue
            }
            
            sourcePieces.append(piece)
        }
        
        switch sourcePieces.count {
        case 0: throw GameStateError.noValidSourcePieces
        case 1: break
        case 2...: throw GameStateError.ambiguousMove
        default: break // We break only because the compiler don't understand that it's actually exhaustive.
        }
        
        // There should always be only a single move pattern that's allowed.
        // If there are more, the move is ambiguous and must be fixed.
        return sourcePieces.first!
    }
}