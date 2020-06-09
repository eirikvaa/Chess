//
//  Board.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

class Board: NSCopying {
    private var cells: [[BoardCell]] = []

    init() {
        for rank in Rank.validRanks {
            var rankCells: [BoardCell] = []

            for file in File.validFiles {
                rankCells.append(.init(coordinate: .init(file: File(stringLiteral: file), rank: Rank(integerLiteral: rank)), piece: nil))
            }

            cells.append(rankCells)
        }

        resetBoard()
    }
    
    private init(cells: [[BoardCell]]) {
        self.cells = cells
    }

    subscript(coordinate: BoardCoordinate) -> Piece? {
        get {
            assert(BoardCoordinateValidator.validate(coordinate), "Invalid coordinate!")
            return cells[coordinate.rank!.rank - 1][coordinate.fileIndex].piece
        }
        set {
            assert(BoardCoordinateValidator.validate(coordinate), "Invalid coordinate!")
            cells[coordinate.rank!.rank - 1][coordinate.fileIndex].piece = newValue
        }
    }

    func performMove(_ move: Move, side: Side, lastMove: Move?) {
        if move.options.contains(.enPassant) {
            let sourcePiece = self[move.source!]
            let lastPawnCoordinate = lastMove!.destination
            self[move.destination] = sourcePiece
            self[move.source!] = nil
            self[lastPawnCoordinate] = nil
            return
        }
        
        if move.options.contains(.promotion) {
            var promotionPiece = move.promotionPiece
            promotionPiece?.side = side
            self[move.destination] = promotionPiece
            self[move.source!] = nil
            return
        }
        
        if move.options.contains(.kingCastling) { // King castling: O-O
            let kingSideRookCoordinate: BoardCoordinate = side == .black ? "h8" : "h1"
            let kingCoordinate: BoardCoordinate = side == .black ? "e8" : "e1"
            let kingSideRook = self[kingSideRookCoordinate]
            let king = self[kingCoordinate]
            
            self[side == .black ? "g8" : "g1"] = king
            self[side == .black ? "f8" : "f1"] = kingSideRook
            self[kingSideRookCoordinate] = nil
            self[kingCoordinate] = nil
            return
        } else if move.options.contains(.queenCastling) { // Queen castling: O-O-O
            let queenSideRookCoordinate: BoardCoordinate = side == .black ? "a8" : "a1"
            let queenSideRook = self[queenSideRookCoordinate]
            let kingCoordinate: BoardCoordinate = side == .black ? "e8" : "e1"
            let king = self[kingCoordinate]
            
            self[side == .black ? "c8" : "c1"] = king
            self[side == .black ? "d8" : "d1"] = queenSideRook
            self[queenSideRookCoordinate] = nil
            self[kingCoordinate] = nil
            return
        }
        
        guard let source = move.source else {
            // TODO: Handle error properly
            return
        }
        
        var sourcePiece = self[source]

        sourcePiece?.moved = true
        self[move.destination] = sourcePiece
        self[move.source!] = nil
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let currentCells = cells
        let board = Board(cells: currentCells)
        return board
    }

    func compareCells(cellA: BoardCell, type: PieceType, side: Side) -> Bool {
        guard let pieceA = cellA.piece else {
            return false
        }

        return pieceA.type == type && self[cellA.coordinate]?.side == side
    }

    func getPieces(of type: PieceType, side: Side) -> [Piece] {
        var pieces = [Piece]()

        for row in cells {
            let correctPieces = row
                .filter { compareCells(cellA: $0, type: type, side: side) }
                .compactMap { $0.piece }
            pieces.append(contentsOf: correctPieces)
        }

        return pieces
    }

    func getCoordinate(of piece: Piece) -> BoardCoordinate {
        for row in cells {
            for cell in row {
                if cell.piece?.id == piece.id {
                    return cell.coordinate
                }
            }
        }

        // Will never end up here
        return .init(stringLiteral: "")
    }
    
    func tryMovingToSource(source: BoardCoordinate, destination: BoardCoordinate, movePattern: MovePattern, canMoveOver: Bool, side: Side) -> Bool {
        var current = source
        
        for direction in movePattern.directions {
            current = current.move(by: direction, side: side)
            
            if current == destination {
                return true
            }
            
            if self[current] != nil && !canMoveOver {
                return false
            }
        }
        
        return true
    }
    
    /**
     Test if the passed-in move puts the King in check. This will make a copy of the board and try out
     the move in a safe manner before reporting back if the move is illegal or not.
     */
    func testIfMovePutsKingInChess(source: BoardCoordinate, move: Move, side: Side, lastMove: Move?) -> Bool {
        let sandboxBoard = self.copy() as! Board
        let sandboxedMove = (move as! SANMove).copy() as! SANMove // TODO: Fix this abomination
        sandboxedMove.source = source
        
        sandboxBoard.performMove(sandboxedMove, side: side, lastMove: lastMove)
        
        // We avoid checking for the King because the King cannot put another King in check.
        let pieceTypes: [PieceType] = [.queen, .knight, .bishop, .rook, .pawn]
        let attackerSide = side.oppositeSide
        let thisSideKing = sandboxBoard.getPieces(of: .king, side: side)[0]
        let thisSideKingCoordinate = sandboxBoard.getCoordinate(of: thisSideKing)
        
        for pieceType in pieceTypes {
            let attackerPieces = sandboxBoard.getPieces(of: pieceType, side: attackerSide)
            
            for piece in attackerPieces {
                let sourceCoordinate = sandboxBoard.getCoordinate(of: piece)
                let validPattern = piece.validPattern(source: sourceCoordinate, destination: thisSideKingCoordinate)
                
                if piece.type == .pawn {
                    if !piece.moved {
                        let blackPredicate = attackerSide == .black && [[.south], [.south, .south], [.southWest], [.southEast]].contains(validPattern)
                        let whitePredicate = attackerSide == .white && [[.north], [.north, .north], [.northWest], [.northEast]].contains(validPattern)
                        if !blackPredicate && !whitePredicate {
                            continue
                        }
                    } else if piece.moved {
                        let blackPredicate = attackerSide == .black && [[.south], [.southWest], [.southEast]].contains(validPattern)
                        let whitePredicate = attackerSide == .white && [[.north], [.northWest], [.northEast]].contains(validPattern)
                        if !blackPredicate && !whitePredicate {
                            continue
                        }
                    }
                }
                
                guard validPattern.directions.count > 0 else {
                    continue
                }
                
                guard sandboxBoard.tryMovingToSource(source: sourceCoordinate, destination: thisSideKingCoordinate, movePattern: validPattern, canMoveOver: false, side: side) else {
                    continue
                }
                
                var current = sourceCoordinate
                for direction in validPattern.directions {
                    if [.north, .south].contains(direction) && piece.type == .pawn {
                        continue
                    }
                    
                    current = current.move(by: direction, side: attackerSide)
                    
                    guard current.isValid else {
                        break
                    }
                    
                    if self[current]?.type == .king {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    /**
     Checkmate is the end-position in which the King has nowhere to move.
     This implemented by trying out every possible valid move for the King
     and seeing if all of the moves result in the King being in check.
     
     TODO:  Implement the ability to avoid checkmate by moving another one
            of the players own pieces, either through blocking or capturing.
     */
    func testIfCheckMate(side: Side) -> Bool {
        guard let myKing = getPieces(of: .king, side: side).first else {
            fatalError("The king is missing, which is illegal.")
        }
        
        let possiblePatterns = myKing.validPatterns
        var validPatterns: [MovePattern] = []
        
        for pattern in possiblePatterns {
            guard isValidDestination(with: pattern, for: myKing, on: side) else {
                continue
            }
            
            validPatterns.append(pattern)
        }
        
        for validPattern in validPatterns {
            let sandboxBoard = self.copy() as! Board
            sandboxBoard.execute(movePattern: validPattern, for: myKing, on: side)
            
            if sandboxBoard.isKingInCheck(side: side) {
                return true
            }
        }
        
        return false
    }
    
    func execute(movePattern: MovePattern, for piece: Piece, on side: Side) {
        var source = getCoordinate(of: piece)
        var current = source
        
        movePattern.directions.forEach {
            current = current.move(by: $0, side: side)
        }
        
        self[current] = piece
        self[source] = nil
    }
    
    func isKingInCheck(side: Side) -> Bool {
        // We avoid checking for the King because the King cannot put another King in check.
        let pieceTypes: [PieceType] = [.queen, .knight, .bishop, .rook, .pawn]
        let attackerSide = side.oppositeSide
        let thisSideKing = getPieces(of: .king, side: side)[0]
        let thisSideKingCoordinate = getCoordinate(of: thisSideKing)
        
        for pieceType in pieceTypes {
            let attackerPieces = getPieces(of: pieceType, side: attackerSide)
            
            for piece in attackerPieces {
                let sourceCoordinate = getCoordinate(of: piece)
                let validPattern = piece.validPattern(source: sourceCoordinate, destination: thisSideKingCoordinate)
                
                if piece.type == .pawn {
                    if !piece.moved {
                        let blackPredicate = attackerSide == .black && [[.south], [.south, .south], [.southWest], [.southEast]].contains(validPattern)
                        let whitePredicate = attackerSide == .white && [[.north], [.north, .north], [.northWest], [.northEast]].contains(validPattern)
                        if !blackPredicate && !whitePredicate {
                            continue
                        }
                    } else if piece.moved {
                        let blackPredicate = attackerSide == .black && [[.south], [.southWest], [.southEast]].contains(validPattern)
                        let whitePredicate = attackerSide == .white && [[.north], [.northWest], [.northEast]].contains(validPattern)
                        if !blackPredicate && !whitePredicate {
                            continue
                        }
                    }
                }
                
                guard validPattern.directions.count > 0 else {
                    continue
                }
                
                guard tryMovingToSource(source: sourceCoordinate, destination: thisSideKingCoordinate, movePattern: validPattern, canMoveOver: false, side: side) else {
                    continue
                }
                
                var current = sourceCoordinate
                for direction in validPattern.directions {
                    if [.north, .south].contains(direction) && piece.type == .pawn {
                        continue
                    }
                    
                    current = current.move(by: direction, side: attackerSide)
                    
                    guard current.isValid else {
                        break
                    }
                    
                    if self[current]?.type == .king {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    func isValidDestination(with movePattern: MovePattern, for piece: Piece, on side: Side) -> Bool {
        let sourceCoordinate = getCoordinate(of: piece)
        let destination = getDestination(from: sourceCoordinate, with: movePattern, for: side)
        
        var current = sourceCoordinate
        for direction in movePattern.directions {
            current = current.move(by: direction, side: side)
            
            guard current.isValid else {
                return false
            }
            
            if current == destination {
                if self[current] != nil {
                    return false
                }
            }
        }
        
        return true
    }
    
    func getDestination(from source: BoardCoordinate, with pattern: MovePattern, for side: Side) -> BoardCoordinate {
        var current = source
        
        for direction in pattern.directions {
            current = current.move(by: direction, side: side)
        }
        
        return current
    }
    
    func emptyCell(_ boardCoordinate: BoardCoordinate) -> Bool {
        self[boardCoordinate] == nil
    }
    
    /**
     There are several conditions for performing a valid en passant [1]:
        - the capturing pawn must be on its fifth rank;
        - the captured pawn must be on an adjacent file and must have just moved two squares in a single move (i.e. a double-step move);
        - the capture can only be made on the move immediately after the enemy pawn makes the double-step move; otherwise, the right to capture it en passant is lost.
     
     [1]: https://en.wikipedia.org/wiki/En_passant
     */
    func checkIfValidEnPassant(source: BoardCoordinate, move: Move, pieceType: PieceType, side: Side) -> Bool {
        let isBlackEnPassant = source.rank == 4 && side == .black
        let isWhiteEnPassant = source.rank == 5 && side == .white
        let isCapture = move.options.contains(.capture)
        let destinationIsEmpty = emptyCell(move.destination)
        let pieceIsPawn = pieceType == .pawn
        return (isBlackEnPassant || isWhiteEnPassant) && isCapture && destinationIsEmpty && pieceIsPawn
    }

    func getSourceDestination(side: Side, move: Move) throws -> BoardCoordinate {
        let destination = move.destination
        let pieces = getPieces(of: move.pieceType, side: side)

        for piece in pieces {
            let sourceCoordinate = getCoordinate(of: piece)
            
            let validPattern = piece.validPattern(source: sourceCoordinate, destination: destination)
            
            guard validPattern.directions.count > 0 else {
                continue
            }

            var currentCoordinate = sourceCoordinate
            for direction in validPattern.directions {
                currentCoordinate = currentCoordinate.move(by: direction.sideRelativeDirection(side), side: side)

                if currentCoordinate == destination {
                    return sourceCoordinate
                }
            }
        }

        throw GameError.invalidMove(message: "No valid source position for destination position \(destination) with move \(move).")
    }

    func canAttack(at coordinate: BoardCoordinate, side: Side) -> Bool {
        guard let otherPiece = self[coordinate] else {
            return false
        }

        guard otherPiece.side != side else {
            return false
        }

        return true
    }

    func moveMultipleSteps(direction: Direction, moves: Int, side: Side, canCrossOver: Bool = true, move: Move) throws {
        guard let source = move.source else {
            throw GameError.noPieceInSourcePosition
        }
        
        let destination = move.destination
        var currentCoordinate = source

        for _ in 0 ..< moves {
            currentCoordinate = currentCoordinate.move(by: direction.sideRelativeDirection(side), side: side)

            if currentCoordinate == destination {
                break
            }

            guard let otherPieceInCurrentPosition = self[currentCoordinate] else {
                continue
            }

            if otherPieceInCurrentPosition.side != side, !canCrossOver {
                throw GameError.invalidMove(message: "Cannot move over opposite piece")
            }
        }
    }

    func resetBoard() {
        func assignPieceToSide(piece: inout Piece, side: Side) {
            piece.side = side
        }

        var whiteBackRank: [Piece] = [Rook(), Knight(), Bishop(), Queen(), King(), Bishop(), Knight(), Rook()]
        var whiteSecondRank: [Piece] = (0 ..< 8).map { _ in Pawn() }

        var blackBackRank: [Piece] = [Rook(), Knight(), Bishop(), Queen(), King(), Bishop(), Knight(), Rook()]
        var blackSecondRank: [Piece] = (0 ..< 8).map { _ in Pawn() }

        for i in 0 ..< whiteBackRank.count {
            assignPieceToSide(piece: &whiteBackRank[i], side: .white)
            assignPieceToSide(piece: &whiteSecondRank[i], side: .white)
            assignPieceToSide(piece: &blackBackRank[i], side: .black)
            assignPieceToSide(piece: &blackSecondRank[i], side: .black)
        }

        for (index, file) in File.validFiles.enumerated() {
            self[BoardCoordinate(file: File(stringLiteral: file), rank: 8)] = blackBackRank[index]
            self[BoardCoordinate(file: File(stringLiteral: file), rank: 7)] = blackSecondRank[index]

            self[BoardCoordinate(file: File(stringLiteral: file), rank: 2)] = whiteSecondRank[index]
            self[BoardCoordinate(file: File(stringLiteral: file), rank: 1)] = whiteBackRank[index]
        }
    }
}

extension Board: CustomStringConvertible {
    var description: String {
        var _description = "    a   b   c   d   e   f   g   h\n"
        _description += "   ––– ––– ––– ––– ––– ––– ––– ––– \n"

        for (index, rank) in cells.reversed().enumerated() {
            _description += "\(8 - index) |"

            for cell in rank {
                let cellContent = cell.piece?.graphicalRepresentation ?? " "
                _description += " " + cellContent + " |"
            }

            _description += " \(8 - index)\n   ––– ––– ––– ––– ––– ––– ––– ––– \n"
        }

        _description += "    a   b   c   d   e   f   g   h\n"

        return _description
    }
}
