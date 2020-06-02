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
    
    func testMorozevichVsKamsky2012() {
        let game =
        """
        1. Nf3 Nf6 2. c4 c5 3. Nc3 b6 4. e3 g6 5. d4 Bg7 6. d5 O-O 7. Be2 e6 8. e4 exd5
        9. e5 Ne4 10. Nxd5 Nc6 11. Qd3 f5 12. exf6 Nxf6 13. Bg5 Bb7 14. Rd1 Qe8 15. Bxf6
        Bxf6 16. O-O Rd8 17. Qd2 Qf7 18. Bd3 Nb4 19. Be4 Nxd5 20. Bxd5 Bxd5 21. cxd5 Qg7
        22. b3 g5 23. h3 h5 24. d6 g4 25. Qd5+ Rf7 26. Ne1 gxh3 27. Rd3 hxg2 28. Nxg2 h4
        29. Kh1 Qg5 30. Qe4 Rg7 31. Ne3 h3 32. Rdd1 Qe5 33. Qf3 Rf8 34. Nf5 Rg6 35. Rde1
        Qc3 36. Qd5+ 1-0
        """
        let moves = PGNGameReader.read(textRepresentation: game)
        assertNonThrowingGame(moves)
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
    
    func assertNonThrowingGame(_ moves: [Move]) {
        let game = TestGameExecutor(moves: moves)
        XCTAssertNoThrow(try game.play())
    }
}
