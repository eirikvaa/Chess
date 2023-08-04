//
//  CoordinateTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 07/12/2020.
//

import XCTest

class CoordinateTests: XCTestCase {
    func testSingleNorth() {
        let source: Coordinate = "e2"

        let destination = source.applyDirection(.north)

        XCTAssertEqual(destination, "e3")
    }

    func testDoubleNorth() {
        let source: Coordinate = "e2"

        let destination = source
            .applyDirection(.north)?
            .applyDirection(.north)

        XCTAssertEqual(destination, "e4")
    }

    func testNorthEastDiagonal() {
        let source: Coordinate = "e2"

        let destination = source.applyDirection(.northEast)

        XCTAssertEqual(destination, "f3")
    }

    func testSouthWestDiagonal() {
        let source: Coordinate = "e2"

        let destination = source.applyDirection(.southWest)

        XCTAssertEqual(destination, "d1")
    }
}
