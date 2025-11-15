//
//  BoardTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 25/12/2020.
//

import Testing
import XCTest

@testable import Chess

@Suite
struct BoardTests {
    @Test
    func doublePawnMove() throws {
        let board = Board()
        let coordinates = board.getCoordinates(from: "e2", to: "e4", given: .double(.north, .north))
        #expect(coordinates == ["e3", "e4"])
    }

    @Test
    func singlePawnMoveCannotReach() throws {
        let board = Board()
        let coordinates = board.getCoordinates(from: "e2", to: "e4", given: .single(.north))
        #expect(coordinates == [])
    }

    @Test
    func bishopDiagonalCanReach() throws {
        let board = Board()
        let coordinates = board.getCoordinates(from: "c1", to: "f4", given: .continuous(.northEast))
        #expect(coordinates == ["d2", "e3", "f4"])
    }

    @Test
    func knightMoveCanReach() throws {
        let board = Board()
        let coordinates = board.getCoordinates(
            from: "g1", to: "f3", given: .shape(.north, .north, .west))
        #expect(coordinates == ["g2", "g3", "f3"])
    }
}
