//
//  GameExecutor.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

protocol GameExecutor: class {
    var isCheckMate: Bool { get set }
    var winner: Side? { get set }
    init (moveFormatValidator: MoveFormatValidator)
    func play() throws
}

class TestGameExecutor: GameExecutor {
    var isCheckMate = false
    var winner: Side?
    
    private var moves: [String]
    private var realMoves: [Move] = []
    private let moveFormatValidator: MoveFormatValidator

    required init(moveFormatValidator: MoveFormatValidator) {
        self.moveFormatValidator = moveFormatValidator
        self.moves = []
    }
    
    convenience init(moves: [String], moveFormatValidator: MoveFormatValidator) {
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
                try MoveValidator.validate($0, board: board, currentSide: currentSide, lastMove: lastMove)
                
                board.performMove($0, side: currentSide, lastMove: lastMove)
                round += 1
                currentSide = currentSide.oppositeSide
                lastMove = $0
            }
        } else {
            try moves.forEach {
                let moveInterpreter = MoveFabric.create(moveType: .algebraic)
                let interpretedMove = try moveInterpreter.interpret($0)
                
                try MoveValidator.validate(interpretedMove, board: board, currentSide: currentSide, lastMove: lastMove)
                
                board.performMove(interpretedMove, side: currentSide, lastMove: lastMove)
                
                if board.isKingInCheck(side: currentSide.oppositeSide) {
                    print("\(currentSide.name) won as \(currentSide.oppositeSide.name) is check mate.")
                    isCheckMate = true
                    winner = currentSide
                    return
                }
                
                round += 1
                currentSide = currentSide.oppositeSide
                lastMove = interpretedMove
            }
        }
    }
}

class RealGameExecutor: GameExecutor {
    var isCheckMate = false
    var winner: Side?
    
    private let moveFormatValidator: MoveFormatValidator

    required init(moveFormatValidator: MoveFormatValidator) {
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

            do {
                try MoveValidator.validate(move, board: board, currentSide: currentSide, lastMove: lastMove)
            } catch {
                print("Invalid move, please try again.")
                continue
            }
            
            board.performMove(move, side: currentSide, lastMove: lastMove)
            
            if board.isKingInCheck(side: currentSide.oppositeSide) {
                print(board)
                print("\(currentSide.name) won as \(currentSide.oppositeSide.name) is check mate.")
                isCheckMate = true
                winner = currentSide
                return
            }

            round += 1
            currentSide = currentSide.oppositeSide
            lastMove = move
        }
        
        print(board)
    }
}
