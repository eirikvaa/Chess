//
//  Game2Tests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 11/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

import XCTest

class Game2Tests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

private extension Game2Tests {
    func applyMoves(_ moves: String...) throws {
        try Game().applyMoves(Array(moves))
    }
}
