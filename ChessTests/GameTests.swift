//
//  GameTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 27/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import XCTest

class Game2Tests: XCTestCase {
    func testPawnMoveToE4() throws {
        XCTAssertNoThrow(try applyMoves(
            "e4"
        ))
    }

    func testKnightToC3() throws {
        XCTAssertNoThrow(try applyMoves(
            "Nc3"
        ))
    }

    func testBishopCannotMoveToPieceOccupiedByItsOwnSide() throws {
        XCTAssertThrowsError(try applyMoves(
            "Bd2"
        ))
    }

    func testPawnE4() throws {
        XCTAssertNoThrow(try applyMoves(
            "e4"
        ))
    }

    func testKnightDoubleMovesAndCapturesPawn() throws {
        XCTAssertNoThrow(try applyMoves(
            "Nc3", "d5", "Nxd5"
        ))
    }

    func testPawnsCannotAttackForward() throws {
        XCTAssertThrowsError(try applyMoves(
            "e4", "e5", "xe5"
        ))
    }

    func testPawnLegalAttack() throws {
        XCTAssertNoThrow(try applyMoves(
            "e4", "d5", "xd5"
        ))
    }
}

private extension Game2Tests {
    func applyMoves(_ moves: String...) throws {
        try Game().applyMoves(Array(moves))
    }
}
