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
    private let moveFormatValidator: MoveFormatValidator

    init(moveFormatValidator: MoveFormatValidator) {
        self.moveFormatValidator = moveFormatValidator
        self.moves = []
    }
    
    init(moves: [String], moveFormatValidator: MoveFormatValidator) {
        self.init(moveFormatValidator: moveFormatValidator)
        self.moves = moves
    }

    func play() throws {
        let board = Board()
        var side = Side.white
        var round = 0

        try moves.forEach {
            print(board)
            let moveInterpreter = MoveFabric.create(moveType: .algebraic)
            let interpretedMove = try moveInterpreter.interpret($0)
            
            try MoveValidator.validate(interpretedMove, board: board, side: side)
            
            board.performMove(interpretedMove)
            round += 1
            side = side.oppositeSide
        }
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

            try MoveValidator.validate(move, board: board, side: currentSide)
            board.performMove(move)

            round += 1
            currentSide = currentSide.oppositeSide
        }
    }
}
