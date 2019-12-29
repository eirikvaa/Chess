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
        assertMovement(type: .pawn, delta: (0,1), side: .white, expectedPattern: [.north], isAttacking: false)
    }
    
    func testWhitePawnMoveTwoNorthShouldSucceed() {
        assertMovement(type: .pawn, delta: (0,2), side: .white, expectedPattern: [.north, .north], isAttacking: false)
    }
    
    func testBlackPawnMoveNorthShouldSucceed() {
        assertMovement(type: .pawn, delta: (0,-1), side: .black, expectedPattern: [.south], isAttacking: false)
    }
    
    func testBlackPawnMoveTwoNorthShouldSucceed() {
        assertMovement(type: .pawn, delta: (0,-2), side: .black, expectedPattern: [.south, .south], isAttacking: false)
    }
    
    func testPawnNumberOfMovesSingleNorth() {
        assertNumberOfMoves(type: .pawn, movePattern: [.north], expectedValue: 1)
    }
    
    // MARK: Rook
    
    func testBlackRookCanMoveSoutShouldSucceed() {
        assertMovement(type: .rook, delta: (0, -2), side: .white, expectedPattern: [.south, .south])
    }

}

extension PieceTests {
    func assertMovement(type: PieceType, delta: (file: Int, rank: Int), side: Side, expectedPattern: MovePattern, isAttacking: Bool = true) {
        let piece = PieceFabric.create(type)
        let actualPattern = piece.validPattern(delta: .init(x: delta.file, y: delta.rank), side: side, isAttacking: isAttacking)
        XCTAssertEqual(actualPattern, expectedPattern)
    }
    
    func assertNumberOfMoves(type: PieceType, movePattern: MovePattern, expectedValue: Int) {
        let piece = PieceFabric.create(type)
        let numberOfMoves = piece.numberOfMoves(for: movePattern)
        XCTAssertEqual(numberOfMoves, expectedValue)
    }
}
