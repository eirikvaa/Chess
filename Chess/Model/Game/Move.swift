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
    var check = false
    var destination: BoardCoordinate = .init(stringLiteral: "a1")
    var sourceFile: File?
    var sourceRank: Rank?
    var pieceName: Character?
    
    var sourceDestination: BoardCoordinate? {
        guard let sourceFile = sourceFile, let sourceRank = sourceRank else {
            return nil
        }
        
        return .init(file: sourceFile, rank: sourceRank)
    }
    
    init(value: String) {
        self.value = value
        
        isAttacking = value.contains("x")
        check = value.contains("+")
        
        let match = value.range(of: #"[a-h]?[1-8]?x?[a-h][1-8]"#, options: .regularExpression)
        
        let coordinates = String(value[match!])
        destination = .init(stringLiteral: String(coordinates.suffix(2)))
        
        var split = String(value.dropLast(isAttacking ? 3 : 2))
        
        if let first = split.first, ["K", "Q", "B", "N", "R"].contains(first) {
            split = String(split.dropFirst())
        }
        
        if let match = split.range(of: #"[a-h]?[1-8]?"#, options: .regularExpression) {
            let sub = split[match]
            
            switch sub.count {
            case 2:
                sourceFile = String(sub.dropLast())
                sourceRank = Int(String(sub.dropFirst()))!
            case 1:
                sourceFile = String(sub)
            default:
                break
            }
        }
        
        if let match = value.range(of: #"[K|Q|N|B|R]"#, options: .regularExpression) {
            let character = String(value[match]).first
            pieceName = character
            pieceType = PieceFabric.create(character).type
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
        let components = MoveComponents(value: move)
        
        destinationCoordinate = components.destination
        sourceCoordinate = try board!.getSourceDestination(
            pieceName: components.pieceName,
            destination: components.destination,
            side: side,
            isAttacking: components.isAttacking)
    }
}
