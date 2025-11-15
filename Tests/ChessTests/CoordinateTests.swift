//
//  CoordinateTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 07/12/2020.
//

import Testing

@testable import Chess

@Suite
struct CoordinateTests {
    @Test
    func singleNorth() {
        let source: Coordinate = "e2"
        let destination = source.applyDirection(.north)
        #expect(destination == "e3")
    }

    @Test
    func doubleNorth() {
        let source: Coordinate = "e2"
        let destination =
            source
            .applyDirection(.north)?
            .applyDirection(.north)
        #expect(destination == "e4")
    }

    @Test
    func northEastDiagonal() {
        let source: Coordinate = "e2"
        let destination = source.applyDirection(.northEast)
        #expect(destination == "f3")
    }

    @Test
    func southWestDiagonal() {
        let source: Coordinate = "e2"
        let destination = source.applyDirection(.southWest)
        #expect(destination == "d1")
    }
}
