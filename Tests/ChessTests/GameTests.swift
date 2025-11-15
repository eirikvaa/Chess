//
//  GameTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 27/12/2019.
//

@testable import Chess
import Testing

@Suite("GameTests")
struct GameTests {
    @Test("Pawn move to e4")
    func pawnMoveToE4() {
        assertMoves("e4", throws: .noThrow)
    }

    @Test("Knight to c3")
    func knightToC3() {
        assertMoves("Nc3", throws: .noThrow)
    }

    @Test("Bishop cannot move to piece occupied by its own side")
    func bishopCannotMoveToPieceOccupiedByItsOwnSide() {
        assertMoves("B2d", throws: .doThrow)
    }

    @Test("Knight double moves and captures pawn")
    func knightDoubleMovesAndCapturesPawn() {
        assertMoves("Nc3", "d5", "Nxd5", throws: .noThrow)
    }

    @Test("Pawns cannot attack forward")
    func pawnsCannotAttackForward() {
        assertMoves("e4", "e5", "xe5", throws: .doThrow)
    }

    @Test("Pawn legal attack")
    func pawnLegalAttack() {
        assertMoves("e4", "d5", "xd5", throws: .noThrow)
    }

    @Test("White pawn cannot attack backwards")
    func whitePawnCannotAttackBackwards() {
        assertMoves("e4", "d5", "e5", "d4", "xd4", throws: .doThrow)
    }

    @Test("Black queen takes white knight")
    func blackQueenTakesWhiteKnight() {
        assertMoves("Nc3", "d5", "Nxd5", "Qxd5", throws: .noThrow)
    }

    @Test("Rook can move north")
    func rookCanMoveNorth() {
        assertMoves("a4", "a5", "Ra3", throws: .noThrow)
    }

    @Test("Should pick correct rook to h3")
    func shouldPickCorrectRookToH3() {
        assertMoves("a4", "a5", "Ra3", "Ra6", "Rh3", throws: .noThrow)
    }

    @Test("Rook cannot capture own pieces")
    func rookCannotCaptureOwnPieces() {
        assertMoves("Rxb1", throws: .doThrow)
    }

    @Test("Legal king move")
    func legalKingMove() {
        assertMoves("e4", "e5", "Ke2", throws: .noThrow)
    }

    @Test("Pawns cannot move diagonally unless it captures legally")
    func pawnsCannotMoveDiagonallyUnlessItCapturesLegally() {
        assertMoves("Nf3", "g6", throws: .noThrow)
    }

    @Test("Can handle king side castling correctly")
    func canHandleKingSideCastlingCorrectly() {
        assertMoves("Nf3", "g6", "e4", "c5", "c4", "Bg7", "d4", "cxd4", "Nxd4", "Nc6", "Be3",
                    "Nf6", "Nc3", "O-O", throws: .noThrow)
    }

    @Test("White can king side castle")
    func whiteCanKingSideCastle() {
        assertMoves("e4", "e5", "Nf3", "d5", "Bc4", "c5", "O-O", throws: .noThrow)
    }

    @Test("White can queen side castle")
    func whiteCanQueenSideCastle() {
        assertMoves("e4", "e5", "d4", "d5", "Bf4", "c5", "Nc3", "b5", "O-O-O", throws: .noThrow)
    }

    @Test("Black can king side castle")
    func blackCanKingSideCastle() {
        assertMoves("e4", "Nf6", "d4", "e6", "c4", "Bd6", "b4", "O-O", throws: .noThrow)
    }

    @Test("Black can queen side castle")
    func blackCanQueenSideCastle() {
        assertMoves("e4", "d62", "d4", "Bg4", "c4", "Nc64", "b4", "Qd7", "a4", "O-O-O", throws: .noThrow)
    }

    @Test("Valid en passant by white")
    func validEnPassantByWhite() {
        assertMoves("e3", "a6", "e4", "a5", "e5", "f5", "xf6", throws: .noThrow)
    }

    @Test("Valid en passant by black")
    func validEnPassantByBlack() {
        assertMoves("a3", "e5", "a4", "e4", "d4", "exd3", throws: .noThrow)
    }

    @Test("Invalid en passant pawn must move double at first move")
    func invalidEnPassantPawnMustMoveDoubleAtFirstMove() {
        assertMoves("e3", "a6", "e4", "a5", "f6", "b3", "f5", "xf6", throws: .doThrow)
    }

    @Test("Two rooks on same file with partial source coordinate should not end with ambiguous move")
    func twoRooksOnSameFileWithPartialSourceCoordinateShouldNotEndWithAmbiguousMove() {
        assertMoves("Nf3", "g6", "e4", "c5", "c4", "Bg7", "d4", "cxd4", "Nxd4",
                    "Nc6", "Be3", "Nf6", "Nc3", "O-O", "Be2", "d6", "O-O", "Nxd4",
                    "Bxd4", "Bd7", "Qd2", "Bc6", "f3", "a5", "b3", "Nd7", "Be3", "Nc5",
                    "Rab1", throws: .noThrow)
    }

    @Test("Pawn cannot capture forwards")
    func pawnCannotCaptureForwards() {
        assertMoves("Nf3", "g6", "e4", "c5", "c4", "Bg7", "d4", "cxd4", "Nxd4",
                    "Nc6", "Be3", "Nf6", "Nc3", "O-O", "Be2", "d6", "O-O", "Nxd4",
                    "Bxd4", "Bd7", "Qd2", "Bc6", "f3", "a5", "b3", "Nd7", "Be3", "Nc5",
                    "Rab1", "Qb6", "Rfc1", "Rfc8", "Rc2", "h5", "Bf1", "Kh7", "g3", "Qd8",
                    "Bh3", "e6", "Rd1", "Be5", "Nb5", "Qf8", "Qe2", "Rd8", "Bg5", "Rd7", "Nd4",
                    "f5", "Nxc6", "bxc6", "Be3", "Qe7", "Bg2", "Bg7", "Rcd2",
                    "Rad8", "Bxc5", "dxc5", throws: .noThrow)
    }

    @Test("That knight only considers final coordinate in move pattern coordinate sequence")
    func thatKnightOnlyConsidersFinalCoordinateInMovePatternCoordinateSequence() {
        assertMoves("e4", "e5", "Nf3", "Nc6", "Bb5", "Nf6", "d3", "Bc5", "c3", "O-O",
                    "O-O", "d6", "Nbd2", "a6", "Bxc6", "bxc6", "Re1", "Re8", "h3", "Bb6", "Nf1", throws: .noThrow)
    }

    private enum Throw {
        case doThrow
        case noThrow
    }

    private func assertMoves(_ moves: String..., throws: Throw) {
        let game = Game()
        switch `throws` {
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
