//
//  Game2.swift
//  Chess
//
//  Created by Eirik Vale Aase on 05/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

struct GameState {
    let board = Board()
    var currentSide = Side.white
    
    func advance(move: Move) throws -> GameState {
        var nextState = GameState()
        nextState.currentSide = currentSide.opposite
        
        findSourcePiece(move: move)
        
        return nextState
    }
    
    private func findSourcePiece(move: Move) {
        let relevantPieces = board.getAllPieces(type: move.pieceType, side: currentSide)
        print(relevantPieces)
    }
}

class Game2 {
    private var gameState = GameState()
    
    func play() throws {
        print(gameState.board)
        
        while true {
            print("> ", terminator: "")
            guard let userInput = readLine(strippingNewline: true) else {
                continue
            }
            
            let move = try Move(rawMove: userInput)
            
            try executeMove(move: move)
        }
    }
    
    private func executeMove(move: Move) throws {
        gameState = try gameState.advance(move: move)
    }
}
