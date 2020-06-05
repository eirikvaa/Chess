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
    static func validate2(board: Board, side: Side, move: Move, lastMove: Move?) throws -> BoardCoordinate {
        let destination = move.destination
        let isCapture = move.options.contains(.capture)
        let pieces = board.getPieces(of: move.pieceType, side: side)

        for piece in pieces {
            let sourceCoordinate = board.getCoordinate(of: piece)
            let delta = destination - sourceCoordinate
            
            let validPattern = piece.validPattern(delta: delta, side: side, isCapture: isCapture)
            
            guard validPattern.directions.count > 0 else {
                continue
            }
            
            if board.checkIfValidEnPassant(source: sourceCoordinate, move: move, pieceType: piece.type, side: side) {
                move.options.append(.enPassant)
                move.source = sourceCoordinate
                return sourceCoordinate
            }
            
            guard board.tryMovingToSource(source: sourceCoordinate, destination: destination, movePattern: validPattern, canMoveOver: piece.type == .knight, side: side) else {
                continue
            }

            var currentCoordinate = sourceCoordinate
            for direction in validPattern.directions {
                currentCoordinate = currentCoordinate.move(by: direction.sideRelativeDirection(side), side: side)

                if currentCoordinate == destination {
                    // Disambiguate between two pieces when an extra file is provided (like Rdd1).
                    // If two rooks can move to the same cell (say d1), then the extra d (between R and d1)
                    // must be specified. Therefore we check if the rank is nil and the source is not nil.
                    // If this is the case, the move source file and the file of the potential source coordiante
                    // must be the same, otherwise we'll pick the wrong piece.
                    // The else if block does the same, only when an extra rank is provided (like R8g5).
                    if move.source?.file == nil && move.source?.rank != nil {
                        if move.source?.rank != sourceCoordinate.rank {
                            continue
                        }
                    } else if move.source?.rank == nil && move.source?.file != nil {
                        if move.source?.file != sourceCoordinate.file {
                            continue
                        }
                    }
                    
                    if board.testIfMovePutsKingInChess(source: sourceCoordinate, move: move, side: side, lastMove: lastMove) {
                        continue
                    }
                    
                    move.source = sourceCoordinate
                    return sourceCoordinate
                }
            }
        }

        throw GameError.invalidMove(message: "No valid source position for destination position \(destination) with move \(move).")
    }
    
    static func validate(_ move: Move, board: Board, currentSide: Side, lastMove: Move?) throws {
        if move.isCastling() {
            // TODO: Implement validation of castling moves
            return
        }
        
        let isCapture = move.options.contains(.capture)
        let sourceCoordinate = try validate2(board: board, side: currentSide, move: move, lastMove: lastMove)
        
        if move.options.contains(.enPassant) {
            // TODO: Implement validation for en passant
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

        let validPattern = sourcePiece.validPattern(delta: moveDelta, side: currentSide, isCapture: isCapture)
        
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
            case (_, .rook),
                 (_, .queen),
                 (_, .king),
                 (_, .bishop):
                try board.moveMultipleSteps(
                    direction: direction,
                    moves: moveDelta.maximumMagnitude,
                    side: currentSide,
                    canCrossOver: false,
                    move: move)
            case (_, .knight):
                let validAttack = board.canAttack(at: destinationCoordinate, side: currentSide)
                let validMove = destinationPiece == nil

                guard validAttack || validMove else {
                    throw GameError.invalidMove(message: "Must either be a valid attack or valid move.")
                }
            default:
                break
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
