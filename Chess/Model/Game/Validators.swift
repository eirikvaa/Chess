//
//  Validators.swift
//  Chess
//
//  Created by Eirik Vale Aase on 29/05/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

import Foundation

protocol Validator {
    associatedtype Element
    static func validate(_ element: Element) -> Bool
}

struct BoardCoordinateValidator: Validator {
    typealias Element = BoardCoordinate

    static func validate(_ element: BoardCoordinate) -> Bool {
        RankValidator.validate(element.rank!) && FileValidator.validate(element.file!)
    }
}

struct RankValidator: Validator {
    typealias Element = Rank

    static func validate(_ element: Rank) -> Bool {
        Rank.validRanks ~= element.rank
    }
}

struct FileValidator: Validator {
    typealias Element = File

    static func validate(_ element: File) -> Bool {
        "a" ... "h" ~= element.file
    }
}

struct MoveValidator {
    static func validate(_ move: Move, board: Board, currentSide: Side, lastMove: Move?) throws {
        if move.isCastling() {
            // TODO: Implement validation of castling moves
            return
        }
        
        let possibleSourcePieces = board.getPieces(of: move.pieceType, side: currentSide)
        
        let filteredSourceCoordinates: [Piece] = possibleSourcePieces.compactMap {
            let possibleSource = board.getCoordinate(of: $0)
            let delta = move.destination - possibleSource
            let validPattern = $0.validPattern(delta: delta, side: currentSide, isCapture: move.isCapture())
            
            if validPattern.directions.isEmpty {
                return nil
            }
            
            if board.checkIfValidEnPassant(source: possibleSource, move: move, pieceType: $0.type, side: currentSide) {
                move.options.append(.enPassant)
                return $0
            }
            
            guard board.tryMovingToSource(source: possibleSource, destination: move.destination, movePattern: validPattern, canMoveOver: $0.type == .knight, side: currentSide) else {
                return nil
            }
            
            if board.testIfMovePutsKingInChess(source: possibleSource, move: move, side: currentSide, lastMove: lastMove) {
                return nil
            }
            
            var currentCoordinate = possibleSource
            for direction in validPattern.directions {
                currentCoordinate = currentCoordinate.move(by: direction, side: currentSide)

                if currentCoordinate == move.destination {
                    // Disambiguate between two pieces when an extra file is provided (like Rdd1).
                    // If two rooks can move to the same cell (say d1), then the extra d (between R and d1)
                    // must be specified. Therefore we check if the rank is nil and the source is not nil.
                    // If this is the case, the move source file and the file of the potential source coordiante
                    // must be the same, otherwise we'll pick the wrong piece.
                    // The else if block does the same, only when an extra rank is provided (like R8g5).
                    if move.source?.file == nil && move.source?.rank != nil {
                        if move.source?.rank != possibleSource.rank {
                            continue
                        }
                    } else if move.source?.rank == nil && move.source?.file != nil {
                        if move.source?.file != possibleSource.file {
                            continue
                        }
                    }
                    
                    //move.source = sourceCoordinate
                    return $0
                }
            }
            
            return nil
        }
        
        guard filteredSourceCoordinates.count == 1 else {
            throw GameError.invalidMove(message: "[\(move.rawInput)] Found zero or multiple possible source pieces: \(filteredSourceCoordinates.map({board.getCoordinate(of: $0)}))")
        }
        
        let sourceCoordinate = board.getCoordinate(of: filteredSourceCoordinates[0])
        
        if move.isEnPassant() {
            // TODO: Implement validation for en passant
            // move.options.append(.enPassant)
            // move.source = sourceCoordinate
            move.source = sourceCoordinate
            return
        }
        
        move.source = sourceCoordinate
        let destinationCoordinate = move.destination
        let destinationPiece = board[destinationCoordinate]
        let moveDelta = destinationCoordinate - sourceCoordinate
        
        guard let sourcePiece = board[sourceCoordinate] else {
            throw GameError.noPieceInSourcePosition
        }

        let validPattern = sourcePiece.validPattern(delta: moveDelta, side: currentSide, isCapture: move.isCapture())
        
        guard validPattern.directions.count > 0 else {
            throw GameError.invalidMove(message: "No valid directions to destination position")
        }

        guard sourcePiece.side == currentSide else {
            throw GameError.invalidPiece
        }

        if destinationPiece?.side == currentSide {
            throw GameError.invalidMove(message: "Cannot move to position occupied by self")
        }
        
        for direction in validPattern.directions {
            if sourcePiece.type == .pawn {
                if [.north, .south].contains(direction) && destinationPiece != nil {
                    throw GameError.invalidMove(message: "[\(move.rawInput)] Cannot move pawn north -- desination is occupied.")
                } else if [.northEast, .northWest, .southEast, .southWest].contains(direction) && destinationPiece == nil {
                    throw GameError.invalidMove(message: "[\(move.rawInput)] Cannt move pawn diagonally -- destination is empty.")
                }
            }
        }
    }
}

protocol MoveFormatValidator {
    var format: String { get }
    func validate(_ move: String) -> Bool
}


struct SANMoveFormatValidator: MoveFormatValidator {
    var format = ##"(ex[a-h][1-8]e.p)|([K|Q|B|N|R]?[a-h]?[1-8]?)?x?[a-h][1-8]([+|#|Q])?|(O\-O\-O)|(O\-O)"##
    
    func validate(_ move: String) -> Bool {
        return move.range(of: format, options: .regularExpression) != nil
    }
}
