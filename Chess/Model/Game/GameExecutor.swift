//
//  GameExecutor.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

protocol GameExecutor {
    init (moveFormatValidator: MoveFormatValidator)
    func play() throws
}

struct TestGameExecutor: GameExecutor {
    private var moves: [String]
    private var realMoves: [Move] = []
    private let moveFormatValidator: MoveFormatValidator

    init(moveFormatValidator: MoveFormatValidator) {
        self.moveFormatValidator = moveFormatValidator
        self.moves = []
    }
    
    init(moves: [String], moveFormatValidator: MoveFormatValidator) {
        self.init(moveFormatValidator: moveFormatValidator)
        self.moves = moves
    }
    
    init(moves: [Move]) {
        self.realMoves = moves
        self.moves = []
        self.moveFormatValidator = SANMoveFormatValidator()
    }

    func play() throws {
        let board = Board()
        var currentSide = Side.white
        var round = 0
        var lastMove: Move?
        
        if realMoves.count > 0 {
            try realMoves.forEach {
                print(board)
                
                try MoveValidator.validate($0, board: board, currentSide: currentSide, lastMove: lastMove)
                
                print("Playing \($0)")
                
                board.performMove($0, side: currentSide, lastMove: lastMove)
                round += 1
                currentSide = currentSide.oppositeSide
                lastMove = $0
            }
        } else {
            try moves.forEach {
                print(board)
                let moveInterpreter = MoveFabric.create(moveType: .algebraic)
                let interpretedMove = try moveInterpreter.interpret($0)
                
                try MoveValidator.validate(interpretedMove, board: board, currentSide: currentSide, lastMove: lastMove)
                
                board.performMove(interpretedMove, side: currentSide, lastMove: lastMove)
                round += 1
                currentSide = currentSide.oppositeSide
                lastMove = interpretedMove
            }
        }
        
        print(board)
    }
}

struct RealGameExecutor: GameExecutor {
    private let moveFormatValidator: MoveFormatValidator

    init(moveFormatValidator: MoveFormatValidator) {
        self.moveFormatValidator = moveFormatValidator
    }
    
    func play() throws {
        let board = Board()
        var currentSide = Side.white
        var round = 0
        var lastMove: Move?

        while true {
            print(board)

            print("\(currentSide.name), please input a move:")
            let input = readLine(strippingNewline: true) ?? ""

            guard input != "quit" else {
                print("Quitting ...")
                break
            }
            
            let moveFabric = MoveFabric.create(moveType: .algebraic)
            guard let move = try? moveFabric.interpret(input) else {
                print("Invalid move format.")
                continue
            }

            try MoveValidator.validate(move, board: board, currentSide: currentSide, lastMove: lastMove)
            board.performMove(move, side: currentSide, lastMove: lastMove)

            round += 1
            currentSide = currentSide.oppositeSide
            lastMove = move
        }
        
        print(board)
    }
}
