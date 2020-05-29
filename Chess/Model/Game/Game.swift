//
//  Game.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

final class Game {
    private var board = Board()
    private var prePlayedMoves = [String]()
    private var moveType: MoveType = .algebraic
    var currentSide = Side.white

    init(moveType: MoveType = .algebraic, prePlayedMoves: [String] = []) {
        self.moveType = moveType
        self.prePlayedMoves.append(contentsOf: prePlayedMoves)
    }
}

extension Game {
    func startGame(continueAfterPrePlayedMoves: Bool = true) throws {
        board.resetBoard()

        var round = 0

        for move in prePlayedMoves {
            guard let convertedMove = try MoveFabric.create(moveType: moveType, move: move, board: board, side: currentSide) else {
                throw GameError.invalidMoveFormat
            }

            printBoard()

            do {
                try performMoveHandleError(move: convertedMove)
            } catch {
                // If something went wrong when adding the preplayed moves, we did something
                // wrong and should just quit.
                throw error
            }

            finishRound(round: &round, side: currentSide)
        }

        guard continueAfterPrePlayedMoves else {
            printBoard()
            return
        }

        while true {
            printBoard()

            print("\(currentSide.name), please input a move:")
            let input = readLine(strippingNewline: true) ?? ""

            guard input != "quit" else {
                print("Quitting ...")
                break
            }

            guard let move = try? MoveFabric.create(moveType: moveType, move: input, board: board, side: currentSide) else {
                print("Move not on correct format, try again.")
                continue
            }

            do {
                try performMoveHandleError(move: move)
            } catch {
                // If something went wrong during playing, we did something wrong, but don't
                // want to play from the start, so just try again.
                continue
            }

            finishRound(round: &round, side: currentSide)
        }
    }

    func performMoveHandleError(move: MoveProtocol) throws {
        guard let sourcePiece = board[move.sourceCoordinate] else {
            throw GameError.noPieceInSourcePosition
        }

        let destinationPiece = board[move.destinationCoordinate]

        do {
            try validateMove(move: move, sourcePiece: sourcePiece, destinationPiece: destinationPiece)
        } catch let gameError as GameError {
            printErrorMessage(gameError: gameError)
            throw gameError
        } catch {
            print("Something went wrong")
            throw error
        }

        board.performMove(move)
    }

    func validateMove(move: MoveProtocol, sourcePiece: Piece?, destinationPiece: Piece?) throws {
        guard let sourcePiece = sourcePiece else {
            throw GameError.noPieceInSourcePosition
        }

        guard sourcePiece.side == currentSide else {
            throw GameError.invalidPiece
        }

        guard try validateMovePattern(move: move, sourcePiece: sourcePiece, destinationPiece: destinationPiece) else {
            throw GameError.invalidMove(message: "Invalid move pattern!")
        }
    }

    func validateMovePattern(move: MoveProtocol, sourcePiece: Piece, destinationPiece: Piece?) throws -> Bool {
        let sourceCoordinate = move.sourceCoordinate
        let destinationCoordinate = move.destinationCoordinate
        let moveDelta = sourceCoordinate.difference(from: destinationCoordinate)
        let isAttacking = sourcePiece.side != destinationPiece?.side && destinationPiece != nil
        let validPattern = sourcePiece.validPattern(delta: moveDelta, side: currentSide, isAttacking: isAttacking)

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
                    side: currentSide,
                    canCrossOver: false
                )
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

        return true
    }

    func finishRound(round: inout Int, side _: Side) {
        round += 1
        currentSide.changeSide()
    }

    func printErrorMessage(gameError: GameError) {
        switch gameError {
        case .invalidPiece:
            print("You cannot use the piece of an opponent.")
        case .ownPieceInDestinationPosition:
            print("You cannot move a piece to a position taken up by your own pieces.")
        case let .invalidMove(message):
            print(message)
        case .noPieceInSourcePosition:
            print("There is no piece in the source position you entered.")
        case .invalidMoveFormat:
            print("Move was on an invalid format.")
        }
    }

    func printBoard() {
        print(board)
    }
}
