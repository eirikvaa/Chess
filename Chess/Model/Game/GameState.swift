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

    init() {
        print(board)
    }

    /**
     Execute a move and transition the game state to a new state.
     This method can throw by a variety of reasons, see `GameStateError`.
     - Parameters move: The move to execute
     */
    mutating func executeMove(move: inout Move) throws {
        print(move.rawMove)

        if move.isKingSideCastling || move.isQueenSideCastling {
            try handleCastling(move: move)
        } else {
            try handleRegularMove(move: &move)
        }

        print(board)

        currentSide = currentSide.opposite
    }

    private func handleCastling(move: Move) throws {
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

    private mutating func handleRegularMove(move: inout Move) throws {
        let piece = try getSourcePiece(move: &move)

        if move.isEnPassant {
            if let previousPieceDestination = previousMove?.destination {
                board[previousPieceDestination].piece = nil
            }
        }

        let sourceCell = board.getCell(of: piece)
        let destinationCell = board[move.destination!]

        destinationCell.piece = sourceCell.piece
        sourceCell.piece = nil
    }
}

struct PossibleMove: CustomStringConvertible {
    let piece: Piece
    let coordinateSequence: [Coordinate]
    let moveType: MoveType

    var description: String {
        coordinateSequence.map {
            String(describing: $0)
        }.joined(separator: " -> ")
    }
}

private extension GameState {
    // swiftlint:disable cyclomatic_complexity
    func getSourcePiece(move: inout Move) throws -> Piece {
        let possibleSourceCells = board.getAllPieces(
            of: move.pieceType,
            side: currentSide,
            sourceCoordinate: move.source
        )

        let possibleSourcePieces: [Piece] = try possibleSourceCells.compactMap {
            guard let piece = $0.piece else {
                return nil
            }

            guard piece.side == currentSide else {
                return nil
            }

            let possibleCoordinateSequences = getCoordinateSequences(move: move, cell: $0, piece: piece)

            for seq in possibleCoordinateSequences {
                switch move.pieceType {
                case .bishop,
                     .queen,
                     .rook,
                     .king,
                     .knight:
                    for coordinate in seq.coordinateSequence {
                        if move.pieceType == .knight {
                            if coordinate != seq.coordinateSequence.last {
                                continue
                            }
                        }

                        if coordinate == move.destination {
                            if move.isCapture {
                                if let pieceInDestination = board[coordinate].piece {
                                    if pieceInDestination.side != currentSide {
                                        return piece
                                    } else {
                                        return nil
                                    }
                                }
                            } else {
                                if let pieceInDestination = board[coordinate].piece {
                                    if pieceInDestination.side != currentSide {
                                        throw GameStateError.mustMarkCaptureInMove
                                    } else {
                                        return nil
                                    }
                                } else {
                                    return piece
                                }
                            }
                        } else {
                            // Stop if we find a piece in this position and the piece we're moving cannot
                            // move over other pieces
                            if board[coordinate].piece != nil, !piece.canMoveOverOtherPieces {
                                return nil
                            }
                        }
                    }
                case .pawn:
                    switch seq.moveType {
                    case .single:
                        if move.isCapture {
                            return nil
                        }

                        let destination = seq.coordinateSequence[0]
                        if board[destination].piece == nil {
                            return piece
                        } else {
                            return nil
                        }
                    case .double:
                        if move.isCapture {
                            return nil
                        }

                        guard !piece.hasMoved else {
                            return nil
                        }

                        return seq.coordinateSequence.allSatisfy {
                            board[$0].piece == nil
                        } ? piece : nil
                    case .diagonal:
                        guard move.isCapture else {
                            return nil
                        }

                        let destination = seq.coordinateSequence[0]

                        if let destinationPiece = board[destination].piece, destinationPiece.side != currentSide {
                            return piece
                        } else {
                            // If the previous move was made by a pawn that moved double side-by-side with this pawn
                            // that captures towards a cell that has
                            if let previousMove = self.previousMove {
                                // We're capturing towards a cell that another pawn just left
                                // This is not a bullet-proof way of checking for an en passant, but it'll do
                                if previousMove.source.file == destination.file && previousMove.pieceType == .pawn {
                                    move.isEnPassant = true
                                    return piece
                                } else {
                                    return nil
                                }
                            }
                            return nil
                        }
                    default:
                        return nil
                    }
                }
            }

            return nil
        }

        switch possibleSourcePieces.count {
        case 0: throw GameStateError.noValidSourcePieces(message: move.rawMove)
        case 1:
            // Now that we know the source coordinate, remember it
            let piece = possibleSourcePieces[0]
            let coordinateOfPiece = board.getCell(of: piece).coordinate
            move.source = coordinateOfPiece
            return piece
        case 2...: throw GameStateError.ambiguousMove
        default: fatalError("We only fail because the compiler don't understand that it's actually exhaustive.")
        }
    }

    func getCoordinateSequences(move: Move, cell: Cell, piece: Piece) -> [PossibleMove] {
        return piece.movePatterns.compactMap { pattern -> PossibleMove? in
            switch move.pieceType {
            case .queen,
                 .rook,
                 .bishop,
                 .king: return handleContinuousMoves(move: move, cell: cell, pattern: pattern)
            case .knight: return handleKnightMove(move: move, cell: cell, pattern: pattern)
            case .pawn: return handlePawnMove(move: move, cell: cell, pattern: pattern)
            }
        }
    }

    func handlePawnMove(move: Move, cell: Cell, pattern: MovePattern) -> PossibleMove? {
        var currentCoordinate = cell.coordinate
        var possibleCoordinates: [Coordinate] = []

        for direction in pattern.directions {
            if let nextCoordinate = currentCoordinate.applyDirection(direction) {
                possibleCoordinates.append(nextCoordinate)

                if nextCoordinate == move.destination {
                    return .init(
                        piece: cell.piece!,
                        coordinateSequence: possibleCoordinates,
                        moveType: pattern.moveType
                    )
                }

                currentCoordinate = nextCoordinate
            }
        }

        return nil
    }

    func handleKnightMove(move: Move, cell: Cell, pattern: MovePattern) -> PossibleMove? {
        var currentCoordinate: Coordinate? = cell.coordinate
        var possibleCoordinates: [Coordinate] = []

        for direction in pattern.directions {
            currentCoordinate = currentCoordinate?.applyDirection(direction)

            if let currentCoordinate = currentCoordinate {
                possibleCoordinates.append(currentCoordinate)
            } else {
                return nil
            }
        }

        if currentCoordinate == move.destination {
            return .init(
                piece: cell.piece!,
                coordinateSequence: possibleCoordinates,
                moveType: pattern.moveType
            )
        }

        return nil
    }

    func handleContinuousMoves(move: Move, cell: Cell, pattern: MovePattern) -> PossibleMove? {
        var currentCoordinate = cell.coordinate

        guard let direction = pattern.directions.first else {
            fatalError("Impossible")
        }

        var possibleCoordinates: [Coordinate] = []

        while true {
            if let nextCoordinate = currentCoordinate.applyDirection(direction) {
                possibleCoordinates.append(nextCoordinate)

                if nextCoordinate == move.destination {
                    return .init(
                        piece: cell.piece!,
                        coordinateSequence: possibleCoordinates,
                        moveType: pattern.moveType
                    )
                }

                currentCoordinate = nextCoordinate
            } else {
                break
            }
        }

        return nil
    }
}
