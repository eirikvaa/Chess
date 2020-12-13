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
        assertMoves("e4", throws: .noThrow)
    }

    func testKnightToC3() throws {
        assertMoves("Nc3", throws: .noThrow)
    }

    func testBishopCannotMoveToPieceOccupiedByItsOwnSide() throws {
        assertMoves("B2d", throws: .doThrow)
    }

    func testKnightDoubleMovesAndCapturesPawn() throws {
        assertMoves("Nc3", "d5", "Nxd5", throws: .noThrow)
    }

    func testPawnsCannotAttackForward() throws {
        assertMoves("e4", "e5", "xe5", throws: .doThrow)
    }

    func testPawnLegalAttack() throws {
        assertMoves("e4", "d5", "xd5", throws: .noThrow)
    }

    func testWhitePawnCannotAttackBackwards() throws {
        assertMoves("e4", "d5", "e5", "d4", "xd3", throws: .doThrow)
    }
}

private extension Game2Tests {
    enum Throw {
        case doThrow
        case noThrow
    }

    func assertMoves(_ moves: String..., throws: Throw) {
        let game = Game()

        switch `throws` {
        case .doThrow: XCTAssertThrowsError(try game.applyMoves(moves))
        case .noThrow: XCTAssertNoThrow(try game.applyMoves(moves))
        }
    }
}
