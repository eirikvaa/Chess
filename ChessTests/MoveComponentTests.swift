//
//  MoveComponentTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 29/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import XCTest

class MoveComponentTests: XCTestCase {
    func testSimplePawnMove() {
        let move = "e4"
        let c = MoveComponents(value: move)

        XCTAssertEqual(c.check, false)
        XCTAssertEqual(c.isAttacking, false)
        XCTAssertEqual(c.destination, "e4")
        XCTAssertEqual(c.pieceType, .pawn)
        XCTAssertEqual(c.sourceRank, nil)
        XCTAssertEqual(c.sourceFile, nil)
        XCTAssertEqual(c.pieceName, nil)
    }

    func testPawnAttack() {
        let move = "xe4"
        let c = MoveComponents(value: move)

        XCTAssertEqual(c.check, false)
        XCTAssertEqual(c.isAttacking, true)
        XCTAssertEqual(c.destination, "e4")
        XCTAssertEqual(c.pieceType, .pawn)
        XCTAssertEqual(c.sourceRank, nil)
        XCTAssertEqual(c.sourceFile, nil)
        XCTAssertEqual(c.pieceName, nil)
    }

    func testBishopMove() {
        let move = "Bc3"
        let c = MoveComponents(value: move)

        XCTAssertEqual(c.check, false)
        XCTAssertEqual(c.isAttacking, false)
        XCTAssertEqual(c.destination, "c3")
        XCTAssertEqual(c.pieceType, .bishop)
        XCTAssertEqual(c.sourceRank, nil)
        XCTAssertEqual(c.sourceFile, nil)
        XCTAssertEqual(c.pieceName, "B")
    }

    func testBishopAttack() {
        let move = "Bxc3"
        let c = MoveComponents(value: move)

        XCTAssertEqual(c.check, false)
        XCTAssertEqual(c.isAttacking, true)
        XCTAssertEqual(c.destination, "c3")
        XCTAssertEqual(c.pieceType, .bishop)
        XCTAssertEqual(c.sourceRank, nil)
        XCTAssertEqual(c.sourceFile, nil)
        XCTAssertEqual(c.pieceName, "B")
    }

    func testBishopAttackCheck() {
        let move = "Bxc3+"
        let c = MoveComponents(value: move)

        XCTAssertEqual(c.check, true)
        XCTAssertEqual(c.isAttacking, true)
        XCTAssertEqual(c.destination, "c3")
        XCTAssertEqual(c.pieceType, .bishop)
        XCTAssertEqual(c.sourceRank, nil)
        XCTAssertEqual(c.sourceFile, nil)
        XCTAssertEqual(c.pieceName, "B")
    }

    func testRookDisambiguatingWithFile() {
        let move = "Rdf8"
        let c = MoveComponents(value: move)

        XCTAssertEqual(c.check, false)
        XCTAssertEqual(c.isAttacking, false)
        XCTAssertEqual(c.destination, "f8")
        XCTAssertEqual(c.pieceType, .rook)
        XCTAssertEqual(c.sourceRank, nil)
        XCTAssertEqual(c.sourceFile, "d")
        XCTAssertEqual(c.pieceName, "R")
    }

    func testQueenWithFileAndRank() {
        let move = "Qh4xe1"
        let c = MoveComponents(value: move)

        XCTAssertEqual(c.check, false)
        XCTAssertEqual(c.isAttacking, true)
        XCTAssertEqual(c.destination, "e1")
        XCTAssertEqual(c.pieceType, .queen)
        XCTAssertEqual(c.sourceRank, 4)
        XCTAssertEqual(c.sourceFile, "h")
        XCTAssertEqual(c.pieceName, "Q")
    }
}
