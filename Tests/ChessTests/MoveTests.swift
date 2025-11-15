//
//  MoveTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 29/12/2019.
//

import Testing

@testable import Chess

@Suite
struct MoveTests {
    @Test
    func pawnMove() throws {
        let move = try Move(rawMove: "e4")
        #expect(move.destination == "e4")
        #expect(move.pieceType == .pawn)
        #expect(!move.isCapture)
    }

    @Test
    func rookMove() throws {
        let move = try Move(rawMove: "Ra8")
        #expect(move.destination == "a8")
        #expect(move.pieceType == .rook)
        #expect(!move.isCapture)
    }

    @Test
    func queenCapture() throws {
        let move = try Move(rawMove: "Qxe3")
        #expect(move.destination == "e3")
        #expect(move.pieceType == .queen)
        #expect(move.isCapture)
    }

    @Test
    func sourceCoordinateInMove() throws {
        let move = try Move(rawMove: "Ra1c1")
        #expect(move.destination == "c1")
        #expect(move.source == "a1")
        #expect(move.pieceType == .rook)
        #expect(!move.isCapture)
    }

    @Test
    func kingSideCastling() throws {
        let move = try Move(rawMove: "O-O")
        #expect(move.isKingSideCastling)
        #expect(!move.isQueenSideCastling)
        #expect(!move.isCapture)
    }

    @Test
    func rookMovePartialSourceCoordinate() throws {
        let move = try Move(rawMove: "Rab1")
        #expect(!(move.isKingSideCastling || move.isQueenSideCastling))
        #expect(move.pieceType == .rook)
    }

    @Test
    func correctParsingOfPawnMoveWithPartialSourceDisambiguation() throws {
        let move = try Move(rawMove: "dxc5")
        #expect(move.pieceType == .pawn)
        #expect(move.source.file == .init(stringLiteral: "d"))
        #expect(move.source.rank == nil)
    }

    @Test
    func rookMoveWithPartialSourceCoordinateThatCaptures() throws {
        let move = try Move(rawMove: "R1xa7")
        #expect(move.pieceType == .rook)
        #expect(move.source.rank == 1)
        #expect(move.isCapture)
        #expect(move.destination == "a7")
    }
}
