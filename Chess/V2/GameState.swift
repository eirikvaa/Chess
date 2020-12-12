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
        
        let sourcePieces: [Piece] = try possibleSourceCells.compactMap { cell in
            guard let piece = cell.piece else {
                return nil
            }
            
            guard piece.side == currentSide else {
                return nil
            }

            if cell.coordinate == move.source {
                return piece
            }
            
            // Try to start from the possible source coordinate and move one direction at a time
            let possibleMovePatterns = try piece.movePatterns.filter { pattern in
                var currentCoordinate = cell.coordinate
                
                switch pattern.moveType {
                case .shape:
                    // A knight can move over other pieces, so just apply all directions and take it from there
                    for direction in pattern.directions {
                        guard let coordinate = currentCoordinate.applyDirection(direction) else {
                            return false
                        }
                        
                        currentCoordinate = coordinate
                    }
                    
                    // If we're not in the correct destination, this is not the piece we're looking for
                    guard currentCoordinate == move.destination else {
                        return false
                    }
                    
                    // If no piece in destination, move is valid
                    guard let destinationPiece = board[currentCoordinate].piece else {
                        return true
                    }
                    
                    // Can only possibly move there if piece is of opposite side
                    guard destinationPiece.side != currentSide else {
                        return false
                    }
                    
                    // Cannot try to capture if not marking it in the move
                    guard move.isCapture else {
                        throw GameStateError.cannotPerformCaptureWithoutNotingItInMove
                    }
                    
                    return true
                default:
                    break
                }
                
                return false
            }
            
            if possibleMovePatterns.count > 0 {
                return piece
            }
            
            return nil
            
            /*
            // Filter out all illegal move patterns
            let movePatterns = piece.movePatterns.filter { movePattern in
                /*guard let _ = cell.coordinate.getMovePattern(to: move.destination, with: movePattern.moveType)?.directions else {
                    return false
                }*/
                
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
                return nil
            }*/
            
            //return piece
        }
        
        switch sourcePieces.count {
        case 0: throw GameStateError.noValidSourcePieces
        case 1: return sourcePieces.first!
        case 2...: throw GameStateError.ambiguousMove
        default: fatalError("We only fail because the compiler don't understand that it's actually exhaustive.")
        }
    }
}
