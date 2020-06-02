//
//  Move.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

/**
 Protocol for interpreting a move. Will always accept a `String` and return a `Move`.
 */
protocol MoveInterpreter {
    func interpret(_ move: String) throws -> Move
}

/**
 SAN: (S)tandard (A)lgebraic (N)otation
 The move format required by FIDE (Fédération Internationale des Échecs / International Chess Federation).

 The full format I'm working on (which is not the full format used in official chess, I'm sure...) is this beast:
    (ex[a-h][1-8]e.p)|(0\-0\-0)|(0\-0)|([K|Q|B|N|R]?[a-h]?[1-8]?)?x?[a-h][1-8]([+|#|Q])?

 This can be broken down to:
    ex[a-h][1-8]e.p: *En passant*.
        Must be declared first otherwise it'll be only partially matched.
 
    (0\-0\-0)|(0\-0): *Castling*.
        Queen-side and king-side castling, i.e. moving both a rook and the queen/king.
        The dash must be escaped as it is used for ranges (like [a-h]).
        (0-0-0) must be matched before (0-0) otherwise the latter fill match when the former should be matched.
   
   ([K|Q|B|N|R]?[a-h]?[1-8]?)?x?[a-h][1-8]([+|#|Q])?: *Core format*.
       The bulk of the matching. The only required parts are the second pair of [a-h][1-8] as they define
       pawns being moved for the first time. They one can also move either of the other pieces and specify
       the source position. The move can be a capture ('x'), a check (+), check mate (#) or a pawn promotion (Q).
       Pawn can also be promoted to other pieces, but I'll deal with that later.
*/
struct SANMoveInterpreter: MoveInterpreter {
    func interpret(_ move: String) throws -> Move {
        var sourceFile: File?
        var sourceRank: Rank?
        var rawPiece: Piece
        var isCheck = false
        var isMate = false
        var isPromotion = false
        var isCapture = false
        var source: BoardCoordinate?
        let destination: BoardCoordinate
        
        let enPassantFormat = #"ex[a-h][1-8]e.p"#
        if let _ = move.range(of: enPassantFormat, options: .regularExpression) {
            fatalError("Support for en passant moves is not implemented yet.")
        }
        
        let castlingFormat = #"(0\-0\-0)|(0\-0)"#
        if let _ = move.range(of: castlingFormat, options: .regularExpression) {
            fatalError("Support for castling moves is not implemented yet.")
        }
        
        let coreFormat = #"([K|Q|B|N|R]?[a-h]?[1-8]?)?x?[a-h][1-8]([+|#|Q])?"#
        guard let match = move.range(of: coreFormat, options: .regularExpression) else {
            throw GameError.invalidMove(message: "At least the destination coordinate is not specified.")
        }
        
        var matchString = move[match]
        
        if let last = matchString.last {
            switch last {
            case "+":
                isCheck = true
                matchString.removeLast()
            case "#":
                isMate = true
                matchString.removeLast()
            case "Q":
                isPromotion = true
                matchString.removeLast()
            default:
                break
            }
        }
        
        // If we came here then the last two characters in the match must be the destination file and rank.
        destination = BoardCoordinate(stringLiteral: String(matchString.suffix(2)))
        matchString.removeLast(2)
        
        if matchString.contains("x") {
            isCapture = true
            matchString.removeLast()
        }
        
        if let first = matchString.first, ["K", "Q", "B", "N", "R"].contains(first) {
            rawPiece = PieceFabric.create(first)
            matchString.removeFirst()
        } else {
            rawPiece = PieceFabric.create(.pawn)
        }
        
        if let possibleFile = matchString.first, File.validFiles.contains(String(possibleFile)) {
            sourceFile = File(stringLiteral: String(possibleFile))
            matchString.removeFirst()
        }
        
        if let possibleRank = matchString.first, let integerValue = Int(String(possibleRank)), Rank.validRanks.contains(integerValue) {
            sourceRank = Rank(integerLiteral: integerValue)
            matchString.removeFirst()
        }
        
        if matchString.isEmpty == false {
            fatalError("We interpreted the raw move wrong! :-(")
        }
        
        source = .init(file: sourceFile, rank: sourceRank)
        
        var options: [MoveOption] = []
        if isCheck { options.append(.check) }
        if isMate { options.append(.mate) }
        if isCapture { options.append(.capture) }
        if isPromotion { options.append(.promotion) }
        
        let move = SANMove(rawInput: move,
                           piece: rawPiece,
                           source: source,
                           destination: destination,
                           options: options)
        
        return move
    }
}

enum MoveOption {
    case check
    case mate
    case enPassant
    case capture
    case promotion
    case queenCastling
    case kingCastling
}

protocol Move: class, CustomStringConvertible {
    var type: MoveType { get }
    var rawInput: String { get }
    var piece: Piece { get }
    var source: BoardCoordinate? { get set }
    var destination: BoardCoordinate { get }
    var options: [MoveOption] { get }
    var sourceFile: File? { get set }
    var sourceRank: Rank? { get set }
}

class SANMove: Move {
    let type: MoveType = .algebraic
    let rawInput: String
    let piece: Piece
    var source: BoardCoordinate?
    let destination: BoardCoordinate
    let options: [MoveOption]
    var sourceFile: File?
    var sourceRank: Rank?
    
    init(rawInput: String, piece: Piece, source: BoardCoordinate?, destination: BoardCoordinate, options: [MoveOption]) {
        self.rawInput = rawInput
        self.piece = piece
        self.source = source
        self.destination = destination
        self.options = options
    }
    
    var description: String {
        rawInput
    }
}

struct MoveFabric {
    static func create(moveType: MoveType) -> MoveInterpreter {
        switch moveType {
        case .algebraic: return SANMoveInterpreter()
        }
    }
}

enum MoveType {
    case algebraic
}
