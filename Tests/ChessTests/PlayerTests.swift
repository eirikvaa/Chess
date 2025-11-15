//
//  PlayerTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 28/12/2019.
//

import Testing

@testable import Chess

@Suite("PlayerTests")
struct PlayerTests {
    @Test("Opposite of black side should be white")
    func oppositeOfBlackSideShouldBeWhite() {
        let black = Side.black
        #expect(black.opposite == .white)
    }

    @Test("Opposite of white side should be black")
    func oppositeOfWhiteSideShouldBeBlack() {
        let white = Side.white
        #expect(white.opposite == .black)
    }
}
