//
//  GameExecutor.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

/**
 Represents the game flow. All validation and execution to moves are delegated to
 the appropriate classes.
 */
class Game {
    private var gameState = GameState()

    /**
     Start a new game. Will throw if moves are invalid.
     */
    func play() throws {
        while true {
            print(gameState.board)
            print("\(gameState.currentSide)> ", terminator: "")

            guard let userInput = readLine(strippingNewline: true) else {
                continue
            }

            do {
                let move = try Move(rawMove: userInput)
                try gameState.executeMove(move: move)
            } catch Move.MoveValidationError.wrongMoveFormat {
                print("The user entered \(userInput), which is a move in the wrong format. Try agai..")
                continue
            } catch GameState.GameStateError.illegalMove {
                print("\(userInput) is an illegal move. Try again.")
                continue
            } catch GameState.GameStateError.noValidSourcePieces {
                print("There are no valid source pieces that can move to the destination specified by the move \(userInput), try again.")
                continue
            } catch GameState.GameStateError.ambiguousMove {
                print("The move \(userInput) was ambiguous, meaning two or more pieces can move to the same cell. Try again.")
                continue
            } catch GameState.GameStateError.cannotMovePieceOfOppositeSide {
                print("\(gameState.currentSide) cannot move pieces of the opposite side. Try again")
            }
        }
    }

    /**
     Apply a list of moves to advance the board to a certain state.
     - Parameter moves: The list of moves to apply
     */
    func applyMoves(_ moves: [String]) throws {
        let interpretedMoves = try moves.map { try Move(rawMove: $0) }

        for move in interpretedMoves {
            try gameState.executeMove(move: move)
        }
    }
}

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

        let possibleSourcePieces: [(piece: Piece, coordinateSequence: [Coordinate], sourceCorodinate: Coordinate)] = possibleSourceCells.compactMap { cell in
            guard let piece = cell.piece else {
                return nil
            }

            guard piece.side == currentSide else {
                return nil
            }

            let possibleCoordinateSequences: [[Coordinate]] = piece.movePatterns.compactMap { pattern -> [Coordinate] in
                var currentCoordinate = cell.coordinate

                var actualDirections: [Coordinate] = []

                // If there is only one direction in the pattern, let's assume that the move is continuous.
                // If there are two directions, it'll be the pawn's double move.
                // If there are three directions, it'll be the knight, which we don't treat as continuous.
                let continuous = pattern.directions.count == 1 && [.queen, .rook, .bishop].contains(move.pieceType)

                guard continuous else {
                    fatalError("Let's try to implement the general case.")
                }

                guard let direction = pattern.directions.first else {
                    fatalError("GENERAL PLZ")
                }

                while true {
                    if let nextCoordinate = currentCoordinate.applyDirection(direction) {
                        actualDirections.append(nextCoordinate)

                        if nextCoordinate == move.destination {
                            return actualDirections
                        }

                        currentCoordinate = nextCoordinate
                    } else {
                        break
                    }
                }

                return actualDirections
            }

            if possibleCoordinateSequences.count > 0 {
                return (piece, possibleCoordinateSequences[0], cell.coordinate)
            }

            return nil
        }

        switch possibleSourcePieces.count {
        case 0: throw GameStateError.noValidSourcePieces
        case 1: return possibleSourcePieces[0].0
        case 2...: throw GameStateError.ambiguousMove
        default: fatalError("We only fail because the compiler don't understand that it's actually exhaustive.")
        }
    }
}
