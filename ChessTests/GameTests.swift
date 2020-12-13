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

    func testBishopToD2() throws {
        XCTAssertNoThrow(try applyMoves(
            "Bd2"
        ))
    }
}

private extension Game2Tests {
    func applyMoves(_ moves: String...) throws {
        try Game().applyMoves(Array(moves))
    }
}
