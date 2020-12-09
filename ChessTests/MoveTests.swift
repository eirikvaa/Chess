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
        let move = try Move(rawMove: "e4")
        
        XCTAssertEqual(move.destination, "e4")
        XCTAssertEqual(move.pieceType, .pawn)
        XCTAssertEqual(move.isCapture, false)
    }
    
    func testRookMove() throws {
        let move = try Move(rawMove: "Ra8")
        
        XCTAssertEqual(move.destination, "a8")
        XCTAssertEqual(move.pieceType, .rook)
        XCTAssertEqual(move.isCapture, false)
    }
    
    func testQueenCapture() throws {
        let move = try Move(rawMove: "Qxe3")
        
        XCTAssertEqual(move.destination, "e3")
        XCTAssertEqual(move.pieceType, .queen)
        XCTAssertEqual(move.isCapture, true)
    }
    
    func testSourceCoordinateInMove() throws {
        let move = try Move(rawMove: "Ra1c1")
        
        XCTAssertEqual(move.destination, "c1")
        XCTAssertEqual(move.source, "a1")
        XCTAssertEqual(move.pieceType, .rook)
        XCTAssertEqual(move.isCapture, false)
    }
}
