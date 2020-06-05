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
        assertThrowingMoves("a5", message: "Cannot use pieces of an opponent")
    }

    func testBlackTriesToUseWhitePieces() {
        assertThrowingMoves("a3", "a4", message: "Cannot use pieces of an opponent")
    }

    // MARK: Pawn

    func testSinglePawnNorthMoveAtStartShouldSucceed() {
        assertNonThrowingMoves("e3", message: "Should not throw")
    }

    func testDoublePawnNorthMoveAtStartShouldSucceed() {
        assertNonThrowingMoves("e4", message: "Should not throw")
    }

    func testPawnMoveThreeNorthAtStartShouldThrow() {
        assertThrowingMoves("e5", message: "Pawn can only move one or two steps north at start.")
    }

    func testPawnMoveTwoNorthAfterInitialMoveShouldThrow() {
        assertThrowingMoves("e3", "a5", "e5", message: "Pawn can only move one north after initial move.")
    }

    func testPawnAttackNorthWestShouldSucceed() {
        assertNonThrowingMoves("e4", "d5", "xd5", message: "Should not throw")
    }

    func testPawnAttackNorthEastShouldSucceed() {
        assertNonThrowingMoves("e4", "f5", "xf5", message: "Should not throw")
    }

    func testPawnMoveToOccupiedPositionShouldThrow() {
        assertThrowingMoves("e4", "e5", "e5", message: "Pawn cannot move north to an occupied position.")
    }

    func testPawnMoveDiagonallyToUnoccupiedPositionShouldThrow() {
        assertThrowingMoves("xf3", message: "Pawn cannot attack digonally to unoccupied position")
    }

    // MARK: Rook

    func testRookMoveToPositionOccupiedByOwnSideShouldThrow() {
        assertThrowingMoves("Ra2", message: "Rook cannot move to a position occupied by a piece of its own side.")
    }

    func testRookMoveToPositionOccupied2ByOwnSideShouldThrow() {
        assertThrowingMoves("Rb1", message: "Rook cannot move to a position occupied by a piece of its own side.")
    }

    func testRookMoveNorthShouldSucceed() {
        assertNonThrowingMoves("a4", "a5", "Ra3", message: "Rook should be able to move north")
    }

    func testRookMoveEastShouldSucceed() {
        assertNonThrowingMoves("Nc3", "a5", "Rb1", message: "Rook should be able to move east")
    }

    func testRookCannotMoveOverOpponentPiece() {
        assertThrowingMoves("a4", "b5", "Ra3", "a5", "Rb3", "h5", "Rb6", message: "Rook cannot move over opponent piece even though destination position is empty")
    }

    // MARK: Bishop

    func testBishopToAttackPosition1ShouldSucceed() {
        assertNonThrowingMoves("e4", "a5", "Bc4", "a4", "Bf7", message: "Should not throw")
    }

    func testBishopToAttackPosition2ShouldSucceed() {
        assertNonThrowingMoves("d4", "a5", "Bf4", "a4", "Bc7", message: "Should not throw")
    }

    func testBishopCannotMoveNorthEastToPositionOccupiedByOwnPieceShouldThrow() {
        assertThrowingMoves("d2", message: "Bishop cannot move to position occupied by own piece.")
    }

    func testBishopCannotMoveNorthWestToPositionOccupiedByOwnPieceShouldThrow() {
        assertThrowingMoves("b2", message: "Bishop cannot move to position occupied by own piece.")
    }

    // MARK: Knight

    func testKnightValidMoveToEmptyDestinationShouldSucceed() {
        assertNonThrowingMoves("a3", message: "Valid knight move")
    }

    func testKnightValidAttackShouldSucceed() {
        assertNonThrowingMoves("Nc3", "d5", "Nd5", message: "Valid knight attack")
    }

    func testInvalidKnightMoveShouldThrow() {
        assertThrowingMoves("d2", message: "Invalid knight move")
    }

    // MARK: King

    func testKingAttackShouldSucceed() {
        assertNonThrowingMoves("e4", "d5", "e5", "d4", "Ke2", "a5", "Ke3", "a4", "Kd4", message: "Should not throw")
    }

    func testKingCannotMoveToPositionOccupiedByOwnPieceShouldThrow() {
        assertThrowingMoves("e2", message: "King cannot move to position occupied by own piece.")
    }

    // MARK: Queen

    func testQueenToAttackPosition1ShouldSucceed() {
        assertNonThrowingMoves("d4", "e5", "Qd3", "e4", message: "Should not throw")
    }

    func testQueenCannotMoveToPositionOccupiedByOwnPieceShouldThrow() {
        assertThrowingMoves("d2", message: "Queen cannot move to position occupied by own piece.")
    }

    // MARK: Ruy Lopez Opening

    func testRuyLopezOpeningShouldSucceed() {
        assertNonThrowingMoves("e4", "e5", "Nf3", "Nc6", "Bb5", message: "Should not throw")
    }

    // MARK: Algebraic notation

    func testAlgebraicNotationPawnE2ToE4() {
        assertNonThrowingMoves("e4", moveType: .algebraic, message: "Should not throw")
    }

    func testAlgebraicNotationKnightB1ToC3() {
        assertNonThrowingMoves("Nc3", moveType: .algebraic, message: "Should not throw")
    }

    func testBlackQueenCanMoveSeveralStepsSouthEast() {
        assertNonThrowingMoves("e4", "e5", "Ke2", "Qf6", moveType: .algebraic, message: "Should not throw")
    }

    // MARK: Real-life chess games

    func testCapablancaVsSavielly1924() {
        assertNonThrowingMoves(
            "d4", "e6",
            "Nf3", "f5",
            "c4", "Nf6",
            "Bg5", "Be7",
            "Nc3",
            message: "Should not throw"
        )
    }
    
    func testTWIC920PGNFile() throws {
        let games = try PGNGameReader.readFile("twic920")
        
        let startIndex = 5
        var failedGames: [(Int, String)] = []
        for (index, gameString) in games[0...200].enumerated() {
            let movesInGame = PGNGameReader.read(textRepresentation: gameString)
            
            let game = TestGameExecutor(moves: movesInGame)

            do {
                try game.play()
            } catch {
                XCTFail()
                print(error)
                failedGames.append((index, gameString))
            }
            
            //print("Tested the following game[\(startIndex)]:\n\n\(gameString)")
        }
        
        for (index, game) in failedGames {
            print(index)
            print(game)
        }
    }
}

extension GameTests {
    func assertThrowingMoves(_ moves: String..., moveType _: MoveType = .algebraic, message: String, side _: Side = .white) {
        let game = TestGameExecutor(moves: moves, moveFormatValidator: SANMoveFormatValidator())

        XCTAssertThrowsError(try game.play(), message)
    }

    func assertNonThrowingMoves(_ moves: String..., moveType _: MoveType = .algebraic, message: String, side _: Side = .white) {
        let game = TestGameExecutor(moves: moves, moveFormatValidator: SANMoveFormatValidator())

        XCTAssertNoThrow(try game.play(), message)
    }
}
