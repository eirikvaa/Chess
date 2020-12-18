//
//  MoveTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 29/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import XCTest

class MoveTests: XCTestCase {
    func testPawnMove() throws {
        let move = try Move(rawMove: "e4")

        XCTAssertEqual(move.destination, "e4")
        XCTAssertEqual(move.pieceType, .pawn)
        XCTAssertFalse(move.isCapture)
    }

    func testRookMove() throws {
        let move = try Move(rawMove: "Ra8")

        XCTAssertEqual(move.destination, "a8")
        XCTAssertEqual(move.pieceType, .rook)
        XCTAssertFalse(move.isCapture)
    }

    func testQueenCapture() throws {
        let move = try Move(rawMove: "Qxe3")

        XCTAssertEqual(move.destination, "e3")
        XCTAssertEqual(move.pieceType, .queen)
        XCTAssertTrue(move.isCapture)
    }

    func testSourceCoordinateInMove() throws {
        let move = try Move(rawMove: "Ra1c1")

        XCTAssertEqual(move.destination, "c1")
        XCTAssertEqual(move.source, "a1")
        XCTAssertEqual(move.pieceType, .rook)
        XCTAssertFalse(move.isCapture)
    }

    func testKingSideCastling() throws {
        let move = try Move(rawMove: "O-O")

        XCTAssertTrue(move.isKingSideCastling)
        XCTAssertFalse(move.isQueenSideCastling)
        XCTAssertFalse(move.isCapture)
    }

    func testRookMovePartialSourceCoordinate() throws {
        let move = try Move(rawMove: "Rab1")

        XCTAssertFalse(move.isKingSideCastling || move.isQueenSideCastling)
        XCTAssertEqual(move.pieceType, .rook)
    }

    func testSomething() throws {
        let move = try Move(rawMove: "dxc5")

        XCTAssertEqual(move.pieceType, .pawn)
        XCTAssertEqual(move.source.file, .init(stringLiteral: "d"))
        XCTAssertNil(move.source.rank)
    }
}
