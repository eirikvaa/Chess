//
//  Game2.swift
//  Chess
//
//  Created by Eirik Vale Aase on 05/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

struct GameState {
    let board = Board2()
    var currentSide = Side2.white
    
    func advance(move: Move2) -> GameState {
        var nextState = GameState()
        nextState.currentSide = currentSide.opposite
        
        return nextState
    }
}

class Game2 {
    private var gameState = GameState()
    
    func play() throws {
        print(gameState.board)
        
        while true {
            guard let userInput = readLine(strippingNewline: true) else {
                continue
            }
            
            let move = try Move2(rawMove: userInput)
            print(move)
            
            print(userInput)
        }
    }
    
    private func executeMove(move: Move2) {
        gameState = gameState.advance(move: move)
    }
}
