//
//  CoordinateTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 07/12/2020.
//

import Testing

@testable import Chess

@Suite("CoordinateTests")
struct CoordinateTests {
    @Test("Single north")
    func singleNorth() {
        let source: Coordinate = "e2"
        let destination = source.applyDirection(.north)
        #expect(destination == "e3")
    }

    @Test("Double north")
    func doubleNorth() {
        let source: Coordinate = "e2"
        let destination =
            source
            .applyDirection(.north)?
            .applyDirection(.north)
        #expect(destination == "e4")
    }

    @Test("North east diagonal")
    func northEastDiagonal() {
        let source: Coordinate = "e2"
        let destination = source.applyDirection(.northEast)
        #expect(destination == "f3")
    }

    @Test("South west diagonal")
    func southWestDiagonal() {
        let source: Coordinate = "e2"
        let destination = source.applyDirection(.southWest)
        #expect(destination == "d1")
    }
}
