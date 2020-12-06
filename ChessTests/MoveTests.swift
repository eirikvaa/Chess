//
//  MoveTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 29/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import XCTest

@testable import Chess

class MoveTests: XCTestCase {
    func testPawnMove() throws {
        let move = try Move2(rawMove: "e4")
        
        XCTAssertEqual(move.destination, try Coordinate(rawCoordinates: "e4"))
        XCTAssertEqual(move.pieceType, .pawn)
        XCTAssertEqual(move.isCapture, false)
    }
    
    func testRookMove() throws {
        let move = try Move2(rawMove: "Ra8")
        
        XCTAssertEqual(move.destination, try Coordinate(rawCoordinates: "a8"))
        XCTAssertEqual(move.pieceType, .rook)
        XCTAssertEqual(move.isCapture, false)
    }
    
    func testQueenCapture() throws {
        let move = try Move2(rawMove: "Qxe3")
        
        XCTAssertEqual(move.destination, try Coordinate(rawCoordinates: "e3"))
        XCTAssertEqual(move.pieceType, .queen)
        XCTAssertEqual(move.isCapture, true)
    }
}
