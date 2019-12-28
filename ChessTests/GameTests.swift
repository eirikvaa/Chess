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
    
    // MARK: Div
    
    func testWhiteTriesToUseBlackPieces() {
        assertThrowingMoves("a7a5", message: "Cannot use pieces of an opponent")
    }
    
    func testBlackTriesToUseWhitePieces() {
        assertThrowingMoves("a2a3", "a3a4", message: "Cannot use pieces of an opponent")
    }
    
    func testSpecifyingEmptyPositionAsSourceShouldThrow() {
        assertThrowingMoves("a3a4", message: "Must access a position with a piece.")
    }
    
    // MARK: Pawn

    func testSinglePawnNorthMoveAtStartShouldSucceed() {
        assertNonThrowingMoves("e2e3", message: "Should not throw")
    }
    
    func testDoublePawnNorthMoveAtStartShouldSucceed() {
        assertNonThrowingMoves("e2e4", message: "Should not throw")
    }
    
    func testPawnMoveThreeNorthAtStartShouldThrow() {
        assertThrowingMoves("e2e5", message: "Pawn can only move one or two steps north at start.")
    }
    
    func testPawnMoveTwoNorthAfterInitialMoveShouldThrow() {
        assertThrowingMoves("e2e3", "a7a5", "e3e5", message: "Pawn can only move one north after initial move.")
    }
    
    func testPawnAttackNorthWestShouldSucceed() {
        assertNonThrowingMoves("e2e4", "d7d5", "e4d5", message: "Should not throw")
    }
    
    func testPawnAttackNorthEastShouldSucceed() {
        assertNonThrowingMoves("e2e4", "f7f5", "e4f5", message: "Should not throw")
    }
    
    func testPawnMoveToOccupiedPositionShouldThrow() {
        assertThrowingMoves("e2e4", "e7e5", "e4e5", message: "Pawn cannot move north to an occupied position.")
    }
    
    func testPawnMoveDiagonallyToUnoccupiedPositionShouldThrow() {
        assertThrowingMoves("e2f3", message: "Pawn cannot attack digonally to unoccupied position")
    }
    
    // MARK: Rook
    
    func testRookMoveToPositionOccupiedByOwnSideShouldThrow() {
        assertThrowingMoves("a1a2", message: "Rook cannot move to a position occupied by a piece of its own side.")
    }
    
    func testRookMoveToPositionOccupied2ByOwnSideShouldThrow() {
        assertThrowingMoves("a1b1", message: "Rook cannot move to a position occupied by a piece of its own side.")
    }
    
    func testRookMoveNorthShouldSucceed() {
        assertNonThrowingMoves("a2a4", "a7a5", "a1a3", message: "Rook should be able to move north")
    }
    
    func testRookMoveEastShouldSucceed() {
        assertNonThrowingMoves("b1c3", "a7a5", "a1b1", message: "Rook should be able to move east")
    }
    
    func testRookCannotMoveOverOpponentPiece() {
        assertThrowingMoves("a2a4", "b7b5", "a1a3", "a7a5", "a3b3", "h7h5", "b3b6", message: "Rook cannot move over opponent piece even though destination position is empty")
    }
    
    // MARK: Bishop
    
    func testBishopToAttackPosition1ShouldSucceed() {
        assertNonThrowingMoves("e2e4", "a7a5", "f1c4", "a5a4", "c4f7", message: "Should not throw")
    }
    
    func testBishopToAttackPosition2ShouldSucceed() {
        assertNonThrowingMoves("d2d4", "a7a5", "c1f4", "a5a4", "f4c7", message: "Should not throw")
    }
    
    func testBishopCannotMoveNorthEastToPositionOccupiedByOwnPieceShouldThrow() {
        assertThrowingMoves("c1d2", message: "Bishop cannot move to position occupied by own piece.")
    }
    
    func testBishopCannotMoveNorthWestToPositionOccupiedByOwnPieceShouldThrow() {
        assertThrowingMoves("c1b2", message: "Bishop cannot move to position occupied by own piece.")
    }
    
    // MARK: Knight
    
    func testKnightValidMoveToEmptyDestinationShouldSucceed() {
        assertNonThrowingMoves("b1a3", message: "Valid knight move")
    }
    
    func testKnightValidAttackShouldSucceed() {
        assertNonThrowingMoves("b1c3", "d7d5", "c3d5", message: "Valid knight attack")
    }
    
    func testInvalidKnightMoveShouldThrow() {
        assertThrowingMoves("b1d2", message: "Invalid knight move")
    }
    
    // MARK: King
    
    func testKingAttackShouldSucceed() {
        assertNonThrowingMoves("e2e4", "d7d5", "e4e5", "d5d4", "e1e2", "a7a5", "e2e3", "a5a4", "e3d4", message: "Should not throw")
    }
    
    func testKingCannotMoveToPositionOccupiedByOwnPieceShouldThrow() {
        assertThrowingMoves("e1e2", message: "King cannot move to position occupied by own piece.")
    }
    
    // MARK: Queen
    
    func testQueenToAttackPosition1ShouldSucceed() {
        assertNonThrowingMoves("d2d4", "e7e5", "d1d3", "e5e4", message: "Should not throw")
    }
    
    func testQueenCannotMoveToPositionOccupiedByOwnPieceShouldThrow() {
        assertThrowingMoves("d1d2", message: "Queen cannot move to position occupied by own piece.")
    }
    
    // MARK: Ruy Lopez Opening
    
    func testRuyLopezOpeningShouldSucceed() {
        assertNonThrowingMoves("e2e4", "e7e5", "g1f3", "b8c6", "f1b5", message: "Should not throw")
    }

}

extension GameTests {
    func assertThrowingMoves(_ moves: Move..., message: String) {
        var game = Game(prePlayedMoves: moves)
        
        XCTAssertThrowsError(try game.startGame(continueAfterPrePlayedMoves: false), message)
    }
    
    func assertNonThrowingMoves(_ moves: Move..., message: String) {
        var game = Game(prePlayedMoves: moves)
        
        XCTAssertNoThrow(try game.startGame(continueAfterPrePlayedMoves: false), message)
    }
}
