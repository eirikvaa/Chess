//
//  GameTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 27/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import XCTest

@testable import Chess

class GameTests: XCTestCase {

    func testSinglePawnNorthMoveAtStartShouldSucceed() {
        var game = createGame(moves: "e2e3")
        
        assertNoGameThrowing(game: &game, message: "Should not throw")
    }
    
    func testDoublePawnNorthMoveAtStartShouldSucceed() {
        var game = createGame(moves: "e2e4")
        
        assertNoGameThrowing(game: &game, message: "Should not throw")
    }
    
    func testBishopToAttackPosition1ShouldSucceed() {
        var game = createGame(moves: "e2e4", "a7a5", "f1c4", "a5a4", "c4f7")
        
        assertNoGameThrowing(game: &game, message: "Should not throw")
    }
    
    func testBishopToAttackPosition2ShouldSucceed() {
        var game = createGame(moves: "d2d4", "a7a5", "c1f4", "a5a4", "f4c7")
        
        assertNoGameThrowing(game: &game, message: "Should not throw")
    }
    
    func testKingToAttackPosition1ShouldSucceed() {
        var game = createGame(moves: "e2e4", "d7d5", "e4e5", "d5d4", "e1e2", "a7a5", "e2e3", "a5a4")
        
        assertNoGameThrowing(game: &game, message: "Should not throw")
    }
    
    func testQueenToAttackPosition1ShouldSucceed() {
        var game = createGame(moves: "d2d4", "e7e5", "d1d3", "e5e4")
        
        assertNoGameThrowing(game: &game, message: "Should not throw")
    }

}

extension GameTests {
    func createGame(moves: Move...) -> Game {
        return Game(prePlayedMoves: moves)
    }
    
    func assertNoGameThrowing(game: inout Game, message: String) {
        XCTAssertNoThrow(try game.startGame(continueAfterPrePlayedMoves: true), message)
    }
}
