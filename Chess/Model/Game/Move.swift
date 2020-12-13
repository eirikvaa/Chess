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
        var pieceType: PieceType
        var isCheck = false
        var isMate = false
        var isPromotion = false
        var promotionDestinationPiece: Piece?
        var isCapture = false
        var source: BoardCoordinate?
        let destination: BoardCoordinate
        var isQueenSideCastling = false
        var isKingSideCastling = false

        let castlingFormat = #"(O\-O\-O)|(O\-O)"#
        if let match = move.range(of: castlingFormat, options: .regularExpression) {
            switch move[match] {
            case "O-O-O": isQueenSideCastling = true
            case "O-O": isKingSideCastling = true
            default: break
            }
        }

        if let promotionIndex = move.firstIndex(of: "=") {
            isPromotion = true
            let promotionToPiece = move[move.index(after: promotionIndex)]

            // We avoid creating new pieces, but in this case it's okay as promotion is technically
            // replacing an old piece with a new one.
            promotionDestinationPiece = PieceFabric.create(promotionToPiece)
        }

        if isKingSideCastling || isQueenSideCastling {
            // It doesn't really matter what we return here, because a castling move will kind of shortcut its way
            // through the entire validation (as of now). The important thing is that it includes the options
            // for either the queen side or king side castling.
            // This should probably be improved, though.
            let option: MoveOption = isKingSideCastling ? .kingCastling : .queenCastling
            return SANMove(rawInput: move, pieceType: .pawn, side: .white, source: nil, destination: "h8", options: [option])
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
            pieceType = PieceTypeFabric.create(first)
            matchString.removeFirst()
        } else {
            pieceType = .pawn
        }

        var sourceFile: File?
        if let possibleFile = matchString.first, File.validFiles.contains(String(possibleFile)) {
            sourceFile = File(stringLiteral: String(possibleFile))
            matchString.removeFirst()
        }

        var sourceRank: Rank?
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
        if isQueenSideCastling { options.append(.queenCastling) }
        if isKingSideCastling { options.append(.kingCastling) }

        let move = SANMove(rawInput: move,
                           pieceType: pieceType,
                           side: .white,
                           source: source,
                           destination: destination,
                           options: options)
        move.promotionPiece = promotionDestinationPiece

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
    var side: Side { get set }
    var pieceType: PieceType { get }
    var source: BoardCoordinate? { get set }
    var destination: BoardCoordinate { get }
    var options: [MoveOption] { get set }
    var promotionPiece: Piece? { get set }
}

extension Move {
    func isCastling() -> Bool {
        options.contains(.kingCastling) || options.contains(.queenCastling)
    }

    func isCapture() -> Bool {
        options.contains(.capture)
    }

    func isEnPassant() -> Bool {
        options.contains(.enPassant)
    }
}

class SANMove: Move, NSCopying {
    let type: MoveType = .algebraic
    let rawInput: String
    var side: Side
    var pieceType: PieceType
    var source: BoardCoordinate?
    let destination: BoardCoordinate
    var options: [MoveOption]
    var promotionPiece: Piece?

    func copy(with zone: NSZone? = nil) -> Any {
        let move = SANMove(rawInput: rawInput, pieceType: pieceType, side: side, source: source, destination: destination, options: options)
        move.source = source
        move.promotionPiece = promotionPiece
        return move
    }

    init(rawInput: String, pieceType: PieceType, side: Side, source: BoardCoordinate?, destination: BoardCoordinate, options: [MoveOption]) {
        self.rawInput = rawInput
        self.side = side
        self.pieceType = pieceType
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
