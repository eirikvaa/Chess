//
//  BoardTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 25/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

import XCTest

class BoardTests: XCTestCase {
    func testDoublePawnMove() throws {
        let board = Board()

        let coordinates = board.getCoordinates(from: "e2", to: "e4", given: .double(.north, .north))

        XCTAssertEqual(coordinates, ["e3", "e4"])
    }

    func testSinglePawnMoveCannotReach() throws {
        let board = Board()

        let coordinates = board.getCoordinates(from: "e2", to: "e4", given: .single(.north))

        XCTAssertEqual(coordinates, [])
    }

    func testBishopDiagonalCanReach() throws {
        let board = Board()

        let coordinates = board.getCoordinates(from: "c1", to: "f4", given: .continuous(.northEast))

        XCTAssertEqual(coordinates, ["d2", "e3", "f4"])
    }

    func testKnightMoveCanReach() throws {
        let board = Board()

        let coordinates = board.getCoordinates(from: "g1", to: "f3", given: .shape(.north, .north, .west))

        XCTAssertEqual(coordinates, ["g2", "g3", "f3"])
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
