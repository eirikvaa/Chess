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
    static func validate(_ move: Move, board: Board, currentSide: Side) throws {
        if move.isCastling() {
            // TODO: Implement validation of castling moves
            return
        }
        
        let isCapture = move.options.contains(.capture)
        let sourceCoordinate = try board.getSourceDestination(side: currentSide, move: move)
        
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
