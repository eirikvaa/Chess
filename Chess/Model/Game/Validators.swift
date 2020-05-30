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
        RankValidator.validate(element.rank) && FileValidator.validate(element.file)
    }
}

struct RankValidator: Validator {
    typealias Element = Rank

    static func validate(_ element: Rank) -> Bool {
        Rank.validRanks ~= element
    }
}

struct FileValidator: Validator {
    typealias Element = File

    static func validate(_ element: File) -> Bool {
        "a" ... "h" ~= element
    }
}

struct MoveValidator {
    static func validate(_ move: Move, board: Board, side: Side) throws {
        let sourceCoordinate = try board.getSourceDestination(piece: move.piece,
                                                              destination: move.destination,
                                                              side: side,
                                                              isAttacking: move.options.contains(.capture))
        move.source = sourceCoordinate

        guard let sourcePiece = board[sourceCoordinate] else {
            throw GameError.noPieceInSourcePosition
        }

        guard sourcePiece.side == side else {
            throw GameError.invalidPiece
        }

        let destinationCoordinate = move.destination
        let destinationPiece = board[destinationCoordinate]
        let moveDelta = sourceCoordinate.difference(from: destinationCoordinate)
        let isAttacking = sourcePiece.side != destinationPiece?.side && destinationPiece != nil
        let validPattern = sourcePiece.validPattern(delta: moveDelta, side: side, isAttacking: isAttacking)

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
            case (_, .rook),
                 (_, .queen),
                 (_, .king),
                 (_, .bishop):
                try board.moveMultipleSteps(
                    source: sourceCoordinate,
                    destination: destinationCoordinate,
                    direction: direction,
                    moves: moveDelta.maximumMagnitude,
                    side: side,
                    canCrossOver: false
                )
            case (_, .knight):
                let validAttack = board.canAttack(at: destinationCoordinate, side: side)
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
