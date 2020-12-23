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
        assertMoves("e4", "d5", "e5", "d4", "xd4", throws: .doThrow)
    }

    func testBlackQueenTakesWhiteKnight() throws {
        assertMoves("Nc3", "d5", "Nxd5", "Qxd5", throws: .noThrow)
    }

    func testRookCanMoveNorth() throws {
        assertMoves("a4", "a5", "Ra3", throws: .noThrow)
    }

    func testShouldPickCorrectRookToH3() throws {
        assertMoves("a4", "a5", "Ra3", "Ra6", "Rh3", throws: .noThrow)
    }

    func testRookCannotCaptureOwnPieces() throws {
        assertMoves("Rxb1", throws: .doThrow)
    }

    func testLegalKingMove() throws {
        assertMoves("e4", "e5", "Ke2", throws: .noThrow)
    }

    func testPawnsCannotMoveDiagonallyUnlessItCapturesLegally() throws {
        assertMoves("Nf3", "g6", throws: .noThrow)
    }

    func testCanHandleKingSideCastlingCorrectly() throws {
        assertMoves("Nf3", "g6", "e4", "c5", "c4", "Bg7", "d4", "cxd4", "Nxd4", "Nc6", "Be3",
                    "Nf6", "Nc3", "O-O", throws: .noThrow)
    }

    func testWhiteCanKingSideCastle() throws {
        assertMoves("e4", "e5", "Nf3", "d5", "Bc4", "c5", "O-O", throws: .noThrow)
    }

    func testWhiteCanQueenSideCastle() throws {
        assertMoves("e4", "e5", "d4", "d5", "Bf4", "c5", "Nc3", "b5", "O-O-O", throws: .noThrow)
    }

    func testBlackCanKingSideCastle() throws {
        assertMoves("e4", "Nf6", "d4", "e6", "c4", "Bd6", "b4", "O-O", throws: .noThrow)
    }

    func testBlackCanQueenSideCastle() throws {
        assertMoves("e4", "d62", "d4", "Bg4", "c4", "Nc64", "b4", "Qd7", "a4", "O-O-O", throws: .noThrow)
    }
    
    func testValidEnPassant() throws {
        assertMoves("e3", "a6", "e4", "a5", "e5", "f5", "xf6", throws: .noThrow)
    }

    func testTwoRooksOnSameFileWithPartialSourceCoordinateShouldNotEndWithAmbiguousMove() throws {
        assertMoves("Nf3", "g6", "e4", "c5", "c4", "Bg7", "d4", "cxd4", "Nxd4",
                    "Nc6", "Be3", "Nf6", "Nc3", "O-O", "Be2", "d6", "O-O", "Nxd4",
                    "Bxd4", "Bd7", "Qd2", "Bc6", "f3", "a5", "b3", "Nd7", "Be3", "Nc5",
                    "Rab1", throws: .noThrow)
    }

    func testPawnCannotCaptureForwards() throws {
        assertMoves("Nf3", "g6", "e4", "c5", "c4", "Bg7", "d4", "cxd4", "Nxd4",
                    "Nc6", "Be3", "Nf6", "Nc3", "O-O", "Be2", "d6", "O-O", "Nxd4",
                    "Bxd4", "Bd7", "Qd2", "Bc6", "f3", "a5", "b3", "Nd7", "Be3", "Nc5",
                    "Rab1", "Qb6", "Rfc1", "Rfc8", "Rc2", "h5", "Bf1", "Kh7", "g3", "Qd8",
                    "Bh3", "e6", "Rd1", "Be5", "Nb5", "Qf8", "Qe2", "Rd8", "Bg5", "Rd7", "Nd4",
                    "f5", "Nxc6", "bxc6", "Be3", "Qe7", "Bg2", "Bg7", "Rcd2",
                    "Rad8", "Bxc5", "dxc5", throws: .noThrow)
    }

    func testThatKnightOnlyConsidersFinalCoordinateInMovePatternCoordinateSequence() throws {
        assertMoves("e4", "e5", "Nf3", "Nc6", "Bb5", "Nf6", "d3", "Bc5", "c3", "O-O",
                    "O-O", "d6", "Nbd2", "a6", "Bxc6", "bxc6", "Re1", "Re8", "h3", "Bb6", "Nf1", throws: .noThrow)
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
