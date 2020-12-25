//
//  GameState.swift
//  Chess
//
//  Created by Eirik Vale Aase on 13/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

import Foundation

/**
 Maintains the game state for a given game.
 Is responsible for always maintaing a valid game state given a move.
 It is basically a function like board(move) -> board
 */
struct GameState {
    let board = Board()
    var currentSide = Side.white
    var previousMove: Move?

    /**
     Execute a move and transition the game state to a new state.
     This method can throw by a variety of reasons, see `GameStateError`.
     - Parameters move: The move to execute
     */
    mutating func executeMove(move: inout Move) throws {
        if move.isCastling {
            handleCastling(move: move)
        } else {
            let piece = try getSourcePiece(move: move)

            if move.isEnPassant {
                if let previousPieceDestination = previousMove?.destination {
                    board[previousPieceDestination].piece = nil
                }
            }

            let sourceCell = board.getCell(of: piece)
            let destinationCell = board[move.destination]

            destinationCell.piece = sourceCell.piece
            sourceCell.piece = nil
        }

        currentSide = currentSide.opposite
    }
}

private extension GameState {
    /**
     When the source coordinate of a piece is not immediately given, we must locate the source cell.
     This method should only return a single piece. If there are none, something's wrong. If there are multiple,
     something's wrong or the move is ambiguous.
     */
    func getSourcePiece(move: Move) throws -> Piece {
        let possibleSourceCells = board.getAllPieces(
            of: move.pieceType,
            side: currentSide,
            sourceCoordinate: move.source
        )

        let possibleSourcePieces = possibleSourceCells.filter {
            guard let piece = $0.piece else {
                return false
            }

            guard piece.side == currentSide else {
                return false
            }

            switch piece.type {
            case .pawn: return validatePawnMove(move: move, cell: $0)
            case .knight: return validateKnightMove(move: move, cell: $0)
            case .king: return validateKingMove(move: move, cell: $0)
            case .rook: return validateRookMove(move: move, cell: $0)
            case .queen: return validateQueenMove(move: move, cell: $0)
            case .bishop: return validateBishopMove(move: move, cell: $0)
            }
        }.compactMap { $0.piece }

        let prunedSourcePieces = pruneAmbiguity(move: move, possibleSourcePieces: possibleSourcePieces)

        switch prunedSourcePieces.count {
        case 0:
            print(board)
            throw GameStateError.noValidSourcePieces(message: move.rawMove)
        case 1:
            // Now that we know the source coordinate, remember it
            let piece = prunedSourcePieces[0]
            let coordinateOfPiece = board.getCell(of: piece).coordinate
            move.source = coordinateOfPiece
            return piece
        case 2...:
            let cellsDesc = prunedSourcePieces
                .map { board.getCell(of: $0) }
                .map { $0.coordinate }
            print(board)
            throw GameStateError.ambiguousMove(message: "\(move.rawMove) is ambiguous. Considered \(cellsDesc)")
        default: fatalError("We only fail because the compiler don't understand that it's actually exhaustive.")
        }
    }

    func pruneAmbiguity(move: Move, possibleSourcePieces: [Piece]) -> [Piece] {
        return possibleSourcePieces.filter {
            let coordinate = board.getCell(of: $0).coordinate

            if let disambiguatedSourceRank = move.source.rank, disambiguatedSourceRank != coordinate.rank {
                return false
            }

            if let disambiguatedSourceFile = move.source.file, disambiguatedSourceFile != coordinate.file {
                return false
            }

            return true
        }
    }

    func validateBishopMove(move: Move, cell: Cell) -> Bool {
        guard let bishop = cell.piece as? Bishop else {
            return false
        }

        return bishop.movePatterns.filter {
            let coordinates = board.getCoordinates(from: cell.coordinate, to: move.destination, given: $0)
            let destinationPiece = board[move.destination].piece

            guard coordinates.last == move.destination else {
                return false
            }

            if move.isCapture {
                let allButLastAreEmpty = coordinates.dropLast().allSatisfy { board.isEmptyCell(at: $0) }

                return allButLastAreEmpty && destinationPiece?.side != currentSide
            } else {
                return coordinates.allSatisfy { board.isEmptyCell(at: $0) }
            }
        }.count == 1
    }

    func validateQueenMove(move: Move, cell: Cell) -> Bool {
        guard let queen = cell.piece as? Queen else {
            return false
        }

        return queen.movePatterns.filter {
            let coordinates = board.getCoordinates(from: cell.coordinate, to: move.destination, given: $0)
            let destinationPiece = board[move.destination].piece

            guard coordinates.last == move.destination else {
                return false
            }

            if move.isCapture {
                let allButLastAreEmpty = coordinates.dropLast().allSatisfy { board.isEmptyCell(at: $0) }

                return allButLastAreEmpty && destinationPiece?.side != currentSide
            } else {
                return coordinates.allSatisfy { board.isEmptyCell(at: $0) }
            }
        }.count == 1
    }

    func validateRookMove(move: Move, cell: Cell) -> Bool {
        guard let rook = cell.piece as? Rook else {
            return false
        }

        return rook.movePatterns.filter {
            let coordinates = board.getCoordinates(from: cell.coordinate, to: move.destination, given: $0)
            let destinationPiece = board[move.destination].piece

            guard coordinates.last == move.destination else {
                return false
            }

            if move.isCapture {
                let allButLastAreEmpty = coordinates.dropLast().allSatisfy { board.isEmptyCell(at: $0) }

                return allButLastAreEmpty && destinationPiece?.side != currentSide
            } else {
                return coordinates.allSatisfy { board.isEmptyCell(at: $0) }
            }
        }.count == 1
    }

    func handleCastling(move: Move) {
        let oldKingCoordinate: Coordinate
        let oldRookCoordinate: Coordinate
        let newKingCoordinate: Coordinate
        let newRookCoordinate: Coordinate

        if move.isKingSideCastling { // O-O
            oldKingCoordinate = Coordinate(stringLiteral: currentSide == .white ? "e1" : "e8")
            oldRookCoordinate = Coordinate(stringLiteral: currentSide == .white ? "h1" : "h8")
            newKingCoordinate = Coordinate(stringLiteral: currentSide == .white ? "g1" : "g8")
            newRookCoordinate = Coordinate(stringLiteral: currentSide == .white ? "f1" : "f8")
        } else { // O-O-O, queen side castling
            oldKingCoordinate = Coordinate(stringLiteral: currentSide == .white ? "e1" : "e8")
            oldRookCoordinate = Coordinate(stringLiteral: currentSide == .white ? "a1" : "a8")
            newKingCoordinate = Coordinate(stringLiteral: currentSide == .white ? "c1" : "c8")
            newRookCoordinate = Coordinate(stringLiteral: currentSide == .white ? "d1" : "d8")
        }

        board[newKingCoordinate].piece = board[oldKingCoordinate].piece
        board[newRookCoordinate].piece = board[oldRookCoordinate].piece
        board[oldKingCoordinate].piece = nil
        board[oldRookCoordinate].piece = nil
    }

    func validatePawnMove(move: Move, cell: Cell) -> Bool {
        guard let pawn = cell.piece as? Pawn else {
            return false
        }

        return pawn.movePatterns.filter {
            let coordinates = board.getCoordinates(from: cell.coordinate, to: move.destination, given: $0)
            let allEmpty = coordinates.allSatisfy { board[$0].piece == nil }
            let destinationPiece = board[move.destination].piece

            guard coordinates.last == move.destination else {
                return false
            }

            switch $0 {
            case .single(let direction):
                if move.isCapture && pawn.validCaptureDirections.contains(direction) {
                    if destinationPiece != nil {
                        return true
                    } else {
                        return isMoveEnPassant(piece: pawn, move: move)
                    }
                } else if !move.isCapture && allEmpty && pawn.validNonCaptureDirections.contains(direction) {
                    return true
                } else {
                    return false
                }
            case .double:
                let lastIsDestination = coordinates.last == move.destination
                return allEmpty && lastIsDestination
            default:
                return false
            }
        }.count == 1
    }

    func isMoveEnPassant(piece: Piece, move: Move) -> Bool {
        // If the previous move was made by a pawn that moved double side-by-side with this pawn
        // that captures towards a cell that has
        guard let previousMove = self.previousMove, previousMove.pieceType == .pawn else {
            return false
        }

        // Get the side of the opposite piece
        let previousSide = currentSide.opposite

        // Get new rank offset. For previous white, it's +1. For previous black, it's -1.
        let enPassantRankOffset = previousSide == .white ? 1 : -1

        // Get the previous source rank
        let previousRank = previousMove.source.rank?.value ?? 0

        // Calculate new rank
        // If previous rank was 2 (white), next en passant rank should be 3 (4 - 1)
        // If previous rank was 7 (black), next en passant rank should be 6 (7 - 1)
        let enPassantRank = previousRank + 1 * enPassantRankOffset

        // Get the destination rank of current piece, the en passant capture
        let currentDestinationRank = move.destination.rank?.value ?? 0

        // Check if the current piece is capturing on the en passant rank we calculated
        guard currentDestinationRank == enPassantRank else {
            return false
        }

        move.isEnPassant = true

        return true
    }

    func validateKnightMove(move: Move, cell: Cell) -> Bool {
        guard let piece = cell.piece else {
            return false
        }

        return piece.movePatterns.filter {
            guard let lastCoordinate = board.getCoordinates(
                    from: cell.coordinate,
                    to: move.destination,
                    given: $0
            ).last, lastCoordinate == move.destination else {
                return false
            }

            switch $0 {
            case .shape:
                let possibleOppositePiece = board[lastCoordinate].piece

                if move.isCapture {
                    return possibleOppositePiece?.side != currentSide
                } else {
                    return possibleOppositePiece == nil
                }
            default:
                return false
            }
        }.count == 1
    }

    func validateKingMove(move: Move, cell: Cell) -> Bool {
        guard let piece = cell.piece else {
            return false
        }

        return piece.movePatterns.filter {
            switch $0 {
            case .single:
                guard let lastCoordinate = board.getCoordinates(
                        from: cell.coordinate,
                        to: move.destination,
                        given: $0
                ).last else {
                    return false
                }

                guard lastCoordinate == move.destination else {
                    return false
                }

                let possibleOppositePiece = board[lastCoordinate].piece

                return
                    (move.isCapture && possibleOppositePiece?.side != currentSide) ||
                    (move.isCapture == false && possibleOppositePiece == nil)
            default:
                return false
            }
        }.count == 1
    }
}
