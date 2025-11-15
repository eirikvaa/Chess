//
//  GameTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 27/12/2019.
//

import Testing

@testable import Chess

@Suite
struct GameTests {
    @Test
    func pawnMoveToE4() {
        assertMoves("e4", shouldThrow: .noThrow)
    }

    @Test
    func knightToC3() {
        assertMoves("Nc3", shouldThrow: .noThrow)
    }

    @Test
    func bishopCannotMoveToPieceOccupiedByItsOwnSide() {
        assertMoves("B2d", shouldThrow: .doThrow)
    }

    @Test
    func knightDoubleMovesAndCapturesPawn() {
        assertMoves("Nc3", "d5", "Nxd5", shouldThrow: .noThrow)
    }

    @Test
    func pawnsCannotAttackForward() {
        assertMoves("e4", "e5", "xe5", shouldThrow: .doThrow)
    }

    @Test
    func pawnLegalAttack() {
        assertMoves("e4", "d5", "xd5", shouldThrow: .noThrow)
    }

    @Test
    func whitePawnCannotAttackBackwards() {
        assertMoves("e4", "d5", "e5", "d4", "xd4", shouldThrow: .doThrow)
    }

    @Test
    func blackQueenTakesWhiteKnight() {
        assertMoves("Nc3", "d5", "Nxd5", "Qxd5", shouldThrow: .noThrow)
    }

    @Test("Rook can move north")
    func rookCanMoveNorth() {
        assertMoves("a4", "a5", "Ra3", shouldThrow: .noThrow)
    }

    @Test("Should pick correct rook to h3")
    func shouldPickCorrectRookToH3() {
        assertMoves("a4", "a5", "Ra3", "Ra6", "Rh3", shouldThrow: .noThrow)
    }

    @Test("Rook cannot capture own pieces")
    func rookCannotCaptureOwnPieces() {
        assertMoves("Rxb1", shouldThrow: .doThrow)
    }

    @Test
    func legalKingMove() {
        assertMoves("e4", "e5", "Ke2", shouldThrow: .noThrow)
    }

    @Test
    func pawnsCannotMoveDiagonallyUnlessItCapturesLegally() {
        assertMoves("Nf3", "g6", shouldThrow: .noThrow)
    }

    @Test
    func canHandleKingSideCastlingCorrectly() {
        assertMoves(
            "Nf3", "g6", "e4", "c5", "c4", "Bg7", "d4", "cxd4", "Nxd4", "Nc6", "Be3",
            "Nf6", "Nc3", "O-O", shouldThrow: .noThrow)
    }

    @Test
    func whiteCanKingSideCastle() {
        assertMoves("e4", "e5", "Nf3", "d5", "Bc4", "c5", "O-O", shouldThrow: .noThrow)
    }

    @Test
    func whiteCanQueenSideCastle() {
        assertMoves("e4", "e5", "d4", "d5", "Bf4", "c5", "Nc3", "b5", "O-O-O", shouldThrow: .noThrow)
    }

    @Test
    func blackCanKingSideCastle() {
        assertMoves("e4", "Nf6", "d4", "e6", "c4", "Bd6", "b4", "O-O", shouldThrow: .noThrow)
    }

    @Test
    func blackCanQueenSideCastle() {
        assertMoves(
            "e4", "d62", "d4", "Bg4", "c4", "Nc64", "b4", "Qd7", "a4", "O-O-O",shouldThrow: .noThrow)
    }

    @Test
    func validEnPassantByWhite() {
        assertMoves("e3", "a6", "e4", "a5", "e5", "f5", "xf6", shouldThrow: .noThrow)
    }

    @Test
    func validEnPassantByBlack() {
        assertMoves("a3", "e5", "a4", "e4", "d4", "exd3", shouldThrow: .noThrow)
    }

    @Test
    func invalidEnPassantPawnMustMoveDoubleAtFirstMove() {
        assertMoves("e3", "a6", "e4", "a5", "f6", "b3", "f5", "xf6", shouldThrow: .doThrow)
    }

    @Test
    func twoRooksOnSameFileWithPartialSourceCoordinateShouldNotEndWithAmbiguousMove() {
        assertMoves(
            "Nf3", "g6", "e4", "c5", "c4", "Bg7", "d4", "cxd4", "Nxd4",
            "Nc6", "Be3", "Nf6", "Nc3", "O-O", "Be2", "d6", "O-O", "Nxd4",
            "Bxd4", "Bd7", "Qd2", "Bc6", "f3", "a5", "b3", "Nd7", "Be3", "Nc5",
            "Rab1", shouldThrow: .noThrow)
    }

    @Test
    func pawnCannotCaptureForwards() {
        assertMoves(
            "Nf3", "g6", "e4", "c5", "c4", "Bg7", "d4", "cxd4", "Nxd4",
            "Nc6", "Be3", "Nf6", "Nc3", "O-O", "Be2", "d6", "O-O", "Nxd4",
            "Bxd4", "Bd7", "Qd2", "Bc6", "f3", "a5", "b3", "Nd7", "Be3", "Nc5",
            "Rab1", "Qb6", "Rfc1", "Rfc8", "Rc2", "h5", "Bf1", "Kh7", "g3", "Qd8",
            "Bh3", "e6", "Rd1", "Be5", "Nb5", "Qf8", "Qe2", "Rd8", "Bg5", "Rd7", "Nd4",
            "f5", "Nxc6", "bxc6", "Be3", "Qe7", "Bg2", "Bg7", "Rcd2",
            "Rad8", "Bxc5", "dxc5", shouldThrow: .noThrow)
    }

    @Test
    func thatKnightOnlyConsidersFinalCoordinateInMovePatternCoordinateSequence() {
        assertMoves(
            "e4", "e5", "Nf3", "Nc6", "Bb5", "Nf6", "d3", "Bc5", "c3", "O-O",
            "O-O", "d6", "Nbd2", "a6", "Bxc6", "bxc6", "Re1", "Re8", "h3", "Bb6", "Nf1",
            shouldThrow: .noThrow)
    }

    @Test
    func twic920() throws {
        let moves = try PGNGameReader.readFile("twic920")
        assertMoves(moves, shouldThrow: .noThrow)
    }

    @Test
    func twic921() throws {
        let moves = try PGNGameReader.readFile("PGNGames/twic921.pgn")
        assertMoves(moves, shouldThrow: .noThrow)
    }

    private enum Throw {
        case doThrow
        case noThrow
    }

    private func assertMoves(_ moves: String..., shouldThrow: Throw) {
        assertMoves(moves, shouldThrow: shouldThrow)
    }

    private func assertMoves(_ moves: [String], shouldThrow: Throw) {
        let game = Game()
        switch shouldThrow {
        case .doThrow:
            #expect(throws: (any Error).self) {
                try game.applyMoves(moves)
            }
        case .noThrow:
            #expect(throws: Never.self) {
                try game.applyMoves(moves)
            }
        }
    }
}
