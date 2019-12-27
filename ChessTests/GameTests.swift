//
//  GameTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 27/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import XCTest

@testable import Chess

class GameTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSinglePawnNorthMove() {
        let moves = ["e2e4"].compactMap { try? Move(move: $0) }
        var game = Game(prePlayedMoves: moves)
        
        XCTAssertNoThrow(
            try game.startGame(continueAfterPrePlayedMoves: false),
            "Should not throw")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
