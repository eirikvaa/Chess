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
    case customExtended
}

struct MoveFabric {
    static func create(moveType: MoveType, move: String, board: Board?, side: Side) throws -> MoveProtocol? {
        switch moveType {
        case .algebraic: return try AlgebraicMove(move: move, board: board, side: side)
        case .customExtended: return try Move(move: move, board: board, side: side)
        }
    }
}

protocol MoveProtocol {
    var piece: Piece? { get }
    var sourceCoordinate: BoardCoordinate { get }
    var destinationCoordinate: BoardCoordinate { get }
    
    init?(move: String, board: Board?, side: Side) throws
}

struct PawnMove {
    let move = "e4"
    
    func inferredMoves() -> MovePattern {
        let pawn = Pawn()
        let moves = pawn.movePatterns
        let end: BoardCoordinate = "e4"
        let side = Side.white
        
        // TODO: Was able to find my way back. I must integrate this into the game and check if the position I find my way back to is occupied by my own pawn and that I only get a single possibility, even though I know that must be the case because the moves are written such that they are unambiguous.
        
        for move in moves {
            var coo = end
            for direction in move.directions {
                switch direction {
                case .north:
                    for _ in 0 ..< 2 {
                        let delta = direction.oppositeDirection.relativeDelta(for: side)
                        print(delta)
                        coo = coo.move(by: delta)
                        print(coo.file, coo.rank)
                    }
                default:
                    break
                }
            }
        }
        
        return [.north]
    }
}

struct AlgebraicMove: MoveProtocol {
    var piece: Piece?
    let sourceCoordinate: BoardCoordinate
    let destinationCoordinate: BoardCoordinate
    
    init?(move: String, board: Board?, side: Side) throws {
        guard let _ = move.lowercased().range(of: #"[K|Q|N|B|R]?[a-h][1-8]"#, options: .regularExpression) else {
            throw GameError.invalidMoveFormat
        }
        
        var possiblePieceName: Character?
        let destination: String
        
        switch move.count {
        case 2:
            destination = move
        case 3:
            possiblePieceName = move.first
            destination = String(move.dropFirst())
        default:
            throw GameError.invalidMoveFormat
        }
        
        destinationCoordinate = BoardCoordinate(stringLiteral: destination)
        sourceCoordinate = try board!.getSourceDestination(
            pieceName: possiblePieceName,
            destination: destinationCoordinate,
            side: side)
    }
}

struct Move: MoveProtocol {
    var piece: Piece?
    let sourceCoordinate: BoardCoordinate
    let destinationCoordinate: BoardCoordinate
    
    init?(move: String, board: Board?, side: Side) throws {
        guard let _ = move.lowercased().range(
            of: #"[a-h][1-8][a-h][1-8]"#,
            options: .regularExpression) else {
            throw GameError.invalidMoveFormat
        }
        
        let characters = Array(move).map { String($0) }
        
        sourceCoordinate = BoardCoordinate(
            file: characters[0],
            rank: Int(characters[1])!)
        destinationCoordinate = BoardCoordinate(
            file: characters[2],
            rank: Int(characters[3])!)
    }
}

extension Move: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self = try! Move(move: value, board: nil, side: .white)!
    }
}
