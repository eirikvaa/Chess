//
//  Validators.swift
//  Chess
//
//  Created by Eirik Vale Aase on 29/05/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//
/*
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
        move.side = currentSide

        if move.isCastling() {
            // TODO: Implement validation of castling moves
            return
        }

        let possibleSourcePieces = board.getPieces(of: move.pieceType, side: currentSide)

        let filteredSourcePieces: [Piece] = possibleSourcePieces.compactMap {
            let possibleSource = board.getCoordinate(of: $0)
            let validPattern = $0.validPattern(source: possibleSource, destination: move.destination)

            // If no initial valid patterns to get from source to destination, break out.
            if validPattern.directions.isEmpty {
                return nil
            }

            if $0.type == .pawn {
                if !$0.moved {
                    let blackPredicate = currentSide == .black && [[.south], [.south, .south], [.southWest], [.southEast]].contains(validPattern)
                    let whitePredicate = currentSide == .white && [[.north], [.north, .north], [.northWest], [.northEast]].contains(validPattern)
                    if !blackPredicate && !whitePredicate {
                        return nil
                    }
                } else if $0.moved {
                    let blackPredicate = currentSide == .black && [[.south], [.southWest], [.southEast]].contains(validPattern)
                    let whitePredicate = currentSide == .white && [[.north], [.northWest], [.northEast]].contains(validPattern)
                    if !blackPredicate && !whitePredicate {
                        return nil
                    }
                }
            }

            // Cannot move pieces of the other side
            guard board[possibleSource]?.side == currentSide else {
                return nil
            }

            // Cannot move own pieces to positions occupied by own pieces
            if board[move.destination]?.side == currentSide {
                return nil
            }

            // Disambiguation happens first with the file, then the rank, then the file and rank.
            if move.source?.file == nil && move.source?.rank != nil {
                if move.source?.rank != possibleSource.rank {
                    return nil
                }
            } else if move.source?.rank == nil && move.source?.file != nil {
                if move.source?.file != possibleSource.file {
                    return nil
                }
            }

            // If the move is an en passant, we shortcut the entire validation by returning this.
            if board.checkIfValidEnPassant(source: possibleSource, move: move, pieceType: $0.type, side: currentSide) {
                move.options.append(.enPassant)
                return $0
            }

            if $0.type == .pawn && !move.isCapture() {
                if possibleSource.file != move.destination.file {
                    return nil
                }
            }

            // Try to move from the source to the destination, jumping over pieces if possible.
            guard board.tryMovingToSource(source: possibleSource, destination: move.destination, movePattern: validPattern, canMoveOver: $0.type == .knight, side: currentSide) else {
                return nil
            }

            // Test if the move we are about to perform will set our king in check. That is an invalid move.
            if board.testIfMovePutsKingInChess(source: possibleSource, move: move, side: currentSide, lastMove: lastMove) {
                return nil
            }

            var currentCoordinate = possibleSource
            for direction in validPattern.directions {
                currentCoordinate = currentCoordinate.move(by: direction, side: currentSide)

                if currentCoordinate == move.destination {
                    return $0
                }
            }

            return nil
        }

        guard let sourcePiece = filteredSourcePieces.first else {
            throw GameError.invalidMove(message: "[\(move.rawInput)] Found zero source pieces.")
        }

        move.source = board.getCoordinate(of: sourcePiece)

        if move.isEnPassant() {
            // TODO: Implement validation for en passant
            return
        }

        let destinationPiece = board[move.destination]

        if sourcePiece.type == .pawn {
            if !move.isCapture() && destinationPiece != nil {
                throw GameError.invalidMove(message: "[\(move.rawInput)] Cannot move pawn north -- desination is occupied.")
            } else if move.isCapture() && destinationPiece == nil {
                throw GameError.invalidMove(message: "[\(move.rawInput)] Cannt move pawn diagonally -- destination is empty.")
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
*/
