//
//  Game2.swift
//  Chess
//
//  Created by Eirik Vale Aase on 05/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

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
            print("> ", terminator: "")
            
            guard let userInput = readLine(strippingNewline: true) else {
                continue
            }
            
            do {
                let move = try Move(rawMove: userInput)
                try gameState.executeMove(move: move)
            } catch Move.MoveValidationError.wrongMoveFormat {
                print("Invalid move format, try again.")
                continue
            } catch GameState.GameStateError.illegalMove {
                print("Illegal move, try again.")
                continue
            } catch GameState.GameStateError.noValidSourcePieces {
                print("No valid source pieces for the given move, try again.")
                continue
            }
        }
    }
}
