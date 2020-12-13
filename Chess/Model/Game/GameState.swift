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

        currentSide = currentSide.opposite
    }
}

struct PossibleMove: CustomStringConvertible {
    let piece: Piece
    let coordinateSequence: [Coordinate]
    let moveType: MoveType

    var description: String {
        coordinateSequence.map { String(describing: $0) }.joined(separator: " -> ")
    }
}

private extension GameState {
    // swiftlint:disable cyclomatic_complexity
    func getSourcePiece(move: Move) throws -> Piece {
        let possibleSourceCells = board.getAllPieces(of: move.pieceType, side: currentSide)
        
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
                case .bishop:
                    for coordinate in seq {
                        if coordinate == move.destination {
                            if move.isCapture {
                                if let pieceInDestination = board[coordinate].piece {
                                    if pieceInDestination.side != currentSide {
                                        return piece
                                    } else {
                                        throw GameStateError.cannotCaptureOwnPiece
                                    }
                                }
                            } else {
                                if let pieceInDestination = board[coordinate].piece {
                                    if pieceInDestination.side != currentSide {
                                        throw GameStateError.cannotPerformCaptureWithoutNotingItInMove
                                    } else {
                                        throw GameStateError.cannotCaptureOwnPiece
                                    }
                                } else {
                                    return piece
                                }
                            }
                        }
                    }
                case .knight:
                    if let endCoordinate = seq.last {
                        if move.isCapture {
                            if let pieceInDestination = board[endCoordinate].piece {
                                if pieceInDestination.side != currentSide {
                                    return piece
                                } else {
                                    throw GameStateError.cannotCaptureOwnPiece
                                }
                            }
                        } else {
                            if let pieceInDestination = board[endCoordinate].piece {
                                if pieceInDestination.side != currentSide {
                                    throw GameStateError.cannotPerformCaptureWithoutNotingItInMove
                                } else {
                                    throw GameStateError.cannotCaptureOwnPiece
                                }
                            } else {
                                return piece
                            }
                        }
                    }
                case .pawn:
                    for coordinate in seq {
                        if coordinate == move.destination {
                            if move.isCapture {
                                if let pieceInDestination = board[coordinate].piece {
                                    if pieceInDestination.side != currentSide {
                                        return piece
                                    } else {
                                        throw GameStateError.cannotCaptureOwnPiece
                                    }
                                }
                            } else {
                                if let pieceInDestination = board[coordinate].piece {
                                    if pieceInDestination.side != currentSide {
                                        throw GameStateError.cannotPerformCaptureWithoutNotingItInMove
                                    } else {
                                        throw GameStateError.cannotCaptureOwnPiece
                                    }
                                } else {
                                    return piece
                                }
                            }
                        }

                        if board[coordinate].piece == nil {
                            return piece
                        }
                    }
                default:
                    break
                }
            }

            return nil
        }

        switch possibleSourcePieces.count {
        case 0: throw GameStateError.noValidSourcePieces
        case 1: return possibleSourcePieces[0]
        case 2...: throw GameStateError.ambiguousMove
        default: fatalError("We only fail because the compiler don't understand that it's actually exhaustive.")
        }
    }

    func getCoordinateSequences(move: Move, cell: Cell, piece: Piece) -> [[Coordinate]] {
        return piece.movePatterns.compactMap { pattern -> [Coordinate]? in
            switch move.pieceType {
            case .queen,
                 .rook,
                 .bishop: return handleContinuousMoves(move: move, cell: cell, pattern: pattern)
            case .knight: return handleKnightMove(move: move, cell: cell, pattern: pattern)
            case .pawn: return handlePawnMove(move: move, cell: cell, pattern: pattern)
            default: return nil
            }
        }
    }

    func handlePawnMove(move: Move, cell: Cell, pattern: MovePattern) -> [Coordinate]? {
        var currentCoordinate = cell.coordinate
        var possibleCoordinates: [Coordinate] = []

        for direction in pattern.directions {
            if let nextCoordinate = currentCoordinate.applyDirection(direction) {
                possibleCoordinates.append(nextCoordinate)

                if nextCoordinate == move.destination {
                    return possibleCoordinates
                }

                currentCoordinate = nextCoordinate
            }
        }

        return nil
    }

    func handleKnightMove(move: Move, cell: Cell, pattern: MovePattern) -> [Coordinate]? {
        var currentCoordinate = cell.coordinate
        var possibleCoordinates: [Coordinate] = []

        for direction in pattern.directions {
            if let nextCoordinate = currentCoordinate.applyDirection(direction) {
                possibleCoordinates.append(nextCoordinate)

                if nextCoordinate == move.destination {
                    return possibleCoordinates
                }

                currentCoordinate = nextCoordinate
            }
        }

        return nil
    }

    func handleContinuousMoves(move: Move, cell: Cell, pattern: MovePattern) -> [Coordinate]? {
        var currentCoordinate = cell.coordinate

        guard let direction = pattern.directions.first else {
            fatalError("Impossible")
        }

        while true {
            var possibleCoordinates: [Coordinate] = []
            if let nextCoordinate = currentCoordinate.applyDirection(direction) {
                possibleCoordinates.append(nextCoordinate)

                if nextCoordinate == move.destination {
                    return possibleCoordinates
                }

                currentCoordinate = nextCoordinate
            } else {
                break
            }
        }

        return nil
    }
}
