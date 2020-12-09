//
//  CoordinateTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 07/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

import XCTest

class CoordinateTests: XCTestCase {

    func testStraightMoves() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let s1: Coordinate = "a1"
        let d1: Coordinate = "c1"
        
        XCTAssertEqual(s1.getMovePattern(to: d1, with: .straight),
                       MovePattern(moveType: .straight, directions: [.east, .east]))
        
        let s2: Coordinate = "a1"
        let d2: Coordinate = "a3"
        
        XCTAssertEqual(s2.getMovePattern(to: d2, with: .straight),
                       MovePattern(moveType: .straight, directions: [.north, .north]))
        
        let s3: Coordinate = "a3"
        let d3: Coordinate = "a1"
        
        XCTAssertEqual(s3.getMovePattern(to: d3, with: .straight),
                       MovePattern(moveType: .straight, directions: [.south, .south]))
        
        let s4: Coordinate = "c1"
        let d4: Coordinate = "a1"
        
        XCTAssertEqual(s4.getMovePattern(to: d4, with: .straight),
                       MovePattern(moveType: .straight, directions: [.west, .west]))
    }

}
