//
//  PlayerTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 28/12/2019.
//

import Testing

@testable import Chess

@Suite
struct PlayerTests {
    @Test
    func oppositeOfBlackSideShouldBeWhite() {
        let black = Side.black
        #expect(black.opposite == .white)
    }

    @Test
    func oppositeOfWhiteSideShouldBeBlack() {
        let white = Side.white
        #expect(white.opposite == .black)
    }
}
