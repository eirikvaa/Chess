//
//  Game.swift
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
        gameState.printBoard()

        while true {
            gameState.printPrompt()

            guard let userInput = readLine(strippingNewline: true) else {
                continue
            }

            do {
                var move = try Move(rawMove: userInput)
                try gameState.executeMove(move: &move)
                gameState.previousMove = move
            } catch Move.MoveValidationError.wrongMoveFormat {
                print("The user entered \(userInput), which is a move in the wrong format. Try agai..")
                continue
            } catch GameState.GameStateError.illegalMove(let message) {
                print("\(userInput) is an illegal move: \(message) Try again.")
                continue
            } catch GameState.GameStateError.noValidSourcePieces {
                print("There are no valid source pieces that can move to the destination specified by the move \(userInput), try again.")
                continue
            } catch GameState.GameStateError.ambiguousMove {
                print("The move \(userInput) was ambiguous, meaning two or more pieces can move to the same cell. Try again.")
                continue
            } catch GameState.GameStateError.cannotMovePieceOfOppositeSide {
                print("The move \(userInput) cannot move pieces of the opposite side. Try again")
            } catch GameState.GameStateError.mustMarkCaptureInMove {
                print("Tried to capture, but did not note it in the move \(userInput)")
                continue
            } catch GameState.GameStateError.cannotMoveOverOtherPieces {
                print("Tried to move over other pieces with the move \(userInput). Try again.")
                continue
            }

            gameState.printBoard()
        }
    }

    /**
     Apply a list of moves to advance the board to a certain state.
     - Parameter moves: The list of moves to apply
     */
    func applyMoves(_ moves: [String]) throws {
        let interpretedMoves = try moves.map {
            try Move(rawMove: $0)
        }

        for var move in interpretedMoves {
            try gameState.executeMove(move: &move)
            gameState.previousMove = move
        }
    }
}
