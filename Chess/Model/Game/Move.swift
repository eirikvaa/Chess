//
//  Move.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

enum MoveType {
    case algebraic
}

struct MoveFabric {
    static func create(moveType: MoveType, move: String, board: Board?, side: Side) throws -> MoveProtocol? {
        switch moveType {
        case .algebraic: return try AlgebraicMove(move: move, board: board, side: side)
        }
    }
}

protocol MoveProtocol {
    var piece: Piece? { get }
    var sourceCoordinate: BoardCoordinate { get }
    var destinationCoordinate: BoardCoordinate { get }
    
    init?(move: String, board: Board?, side: Side) throws
}

struct MoveComponents {
    private let value: String
    var pieceType: PieceType = .pawn
    var isAttacking = false
    var destination: BoardCoordinate = .init(stringLiteral: "a1")
    var pieceName: Character?
    
    init(value: String) {
        self.value = value
        
        isAttacking = value.contains("x")
        destination = .init(stringLiteral: String(value.suffix(2)))
        
        if let match = value.range(of: "[K|Q|B|N|R]", options: .regularExpression) {
            pieceName = String(value[match]).first
            pieceType = PieceFabric.create(pieceName).type
        } else {
            pieceType = .pawn
        }
    }
}

struct AlgebraicMove: MoveProtocol {
    var piece: Piece?
    let sourceCoordinate: BoardCoordinate
    let destinationCoordinate: BoardCoordinate
    
    init?(move: String, board: Board?, side: Side) throws {
        guard let _ = move.lowercased().range(of: #"[K|Q|N|B|R]?[x]?[a-h][1-8]"#, options: .regularExpression) else {
            throw GameError.invalidMoveFormat
        }
        
        let components = MoveComponents(value: move)
        
        destinationCoordinate = components.destination
        sourceCoordinate = try board!.getSourceDestination(
            pieceName: components.pieceName,
            destination: components.destination,
            side: side,
            isAttacking: components.isAttacking)
    }
}
