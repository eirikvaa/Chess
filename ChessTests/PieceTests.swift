//
//  PieceTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import XCTest

@testable import Chess

class PieceTests: XCTestCase {
    // MARK: Pawn

    func testWhitePawnMoveNorthShouldSucceed() {
        assertMovement(type: .pawn, source: "e2", destination: "e3", side: .white, expectedPattern: .one(.north))
    }

    func testWhitePawnMoveTwoNorthShouldSucceed() {
        assertMovement(type: .pawn, source: "e2", destination: "e4", side: .white, expectedPattern: .two(.north))
    }

    func testBlackPawnMoveNorthShouldSucceed() {
        assertMovement(type: .pawn, source: "e7", destination: "e6", side: .black, expectedPattern: .one(.south))
    }

    func testBlackPawnMoveTwoNorthShouldSucceed() {
        assertMovement(type: .pawn, source: "e7", destination: "e5", side: .black, expectedPattern: .two(.south))
    }

    // MARK: Rook

    func testBlackRookCanMoveSoutShouldSucceed() {
        assertMovement(type: .rook, source: "c4", destination: "a4", side: .white, expectedPattern: .two(.west))
    }
}

extension PieceTests {
    func assertMovement(type: PieceType, source: BoardCoordinate, destination: BoardCoordinate, side: Side, expectedPattern: MovePattern, isAttacking: Bool = true) {
        let piece = PieceFabric.create(type)
        let actualPattern = piece.validPattern(source: source, destination: destination)
        XCTAssertEqual(actualPattern, expectedPattern)
    }
}
