//
//  PlayerTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import XCTest

class PlayerTests: XCTestCase {
    func testOppositeOfBlackSideShouldBeWhite() {
        let black = Side.black
        XCTAssertEqual(black.opposite, .white)
    }

    func testOppositeOfWhiteSideShouldBeBlack() {
        let white = Side.white
        XCTAssertEqual(white.opposite, .black)
    }
}
