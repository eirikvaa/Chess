//
//  MoveComponentTests.swift
//  ChessTests
//
//  Created by Eirik Vale Aase on 29/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import XCTest

class MoveComponentTests: XCTestCase {
    func testSimplePawnMove() throws {
        let move = "e4"
        let im = try SANMoveInterpreter().interpret(move)
        assertProperties(move: im, isCheck: false, isCapture: false, destination: "e4", pieceType: .pawn, rank: nil, file: nil)
    }

    func testPawnAttack() throws {
        let move = "xe4"
        let im = try SANMoveInterpreter().interpret(move)
        assertProperties(move: im, isCheck: false, isCapture: true, destination: "e4", pieceType: .pawn, rank: nil, file: nil)
    }

    func testBishopMove() throws {
        let move = "Bc3"
        let im = try SANMoveInterpreter().interpret(move)
        assertProperties(move: im, isCheck: false, isCapture: false, destination: "c3", pieceType: .bishop, rank: nil, file: nil)
    }

    func testBishopAttack() throws {
        let move = "Bxc3"
        let im = try SANMoveInterpreter().interpret(move)
        assertProperties(move: im, isCheck: false, isCapture: true, destination: "c3", pieceType: .bishop, rank: nil, file: nil)
    }

    func testBishopAttackCheck() throws {
        let move = "Bxc3+"
        let im = try SANMoveInterpreter().interpret(move)
        assertProperties(move: im, isCheck: true, isCapture: true, destination: "c3", pieceType: .bishop, rank: nil, file: nil)
    }

    func testRookDisambiguatingWithFile() throws {
        let move = "Rdf8"
        let im = try SANMoveInterpreter().interpret(move)
        assertProperties(move: im, isCheck: false, isCapture: false, destination: "f8", pieceType: .rook, rank: nil, file: "d")
    }

    func testQueenWithFileAndRank() throws {
        let move = "Qh4xe1"
        let im = try SANMoveInterpreter().interpret(move)
        assertProperties(move: im, isCheck: false, isCapture: true, destination: "e1", pieceType: .queen, rank: 4, file: "h")
    }

    func testHei() throws {
        let move = "Qf6"
        let im = try SANMoveInterpreter().interpret(move)
        assertProperties(move: im, isCheck: false, isCapture: false, destination: "f6", pieceType: .queen)
    }
}

extension MoveComponentTests {
    func assertProperties(move: Move, isCheck: Bool, isCapture: Bool, destination: BoardCoordinate, pieceType: PieceType, rank: Rank? = nil, file: File? = nil) {
        XCTAssertEqual(move.options.contains(.check), isCheck)
        XCTAssertEqual(move.options.contains(.capture), isCapture)
        XCTAssertEqual(move.pieceType, pieceType)
        XCTAssertEqual(move.source?.rank, rank)
        XCTAssertEqual(move.source?.file, file)
        XCTAssertEqual(move.destination, destination)
    }
}
