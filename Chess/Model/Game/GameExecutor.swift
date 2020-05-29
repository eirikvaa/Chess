//
//  GameExecutor.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

protocol GameExecutor {
    func play() throws
}

struct TestGameExecutor: GameExecutor {
    private let moves: [String]

    init(moves: [String]) {
        self.moves = moves
    }

    func play() throws {
        let board = Board()
        var side = Side.white
        var round = 0

        try moves.forEach {
            guard let move = try MoveFabric.create(moveType: .algebraic, move: $0, board: board, side: side) else {
                throw GameError.invalidMoveFormat
            }
            
            try MoveValidator.validate(move, board: board, side: side)
            
            board.performMove(move)
            round += 1
            side = side.oppositeSide
        }
    }
}

struct RealGameExecutor: GameExecutor {
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

            guard let move = try? MoveFabric.create(moveType: .algebraic, move: input, board: board, side: currentSide) else {
                print("Move not on correct format, try again.")
                continue
            }

            try MoveValidator.validate(move, board: board, side: currentSide)
            board.performMove(move)

            round += 1
            currentSide = currentSide.oppositeSide
        }
    }
}
