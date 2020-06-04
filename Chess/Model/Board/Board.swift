//
//  Board.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

class Board {
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
            let lastPawnCoordinate = lastMove!.destination
            self[move.destination] = move.piece
            self[move.source!] = nil
            self[lastPawnCoordinate] = nil
        }
        
        if move.options.contains(.kingCastling) {
            let kingSideRookCoordinate: BoardCoordinate = side == .black ? "h8" : "h1"
            let kingCoordinate: BoardCoordinate = side == .black ? "e8" : "e1"
            let kingSideRook = self[kingSideRookCoordinate]
            let king = self[kingCoordinate]
            
            self[side == .black ? "g8" : "g1"] = king
            self[side == .black ? "f8" : "f1"] = kingSideRook
            self[kingSideRookCoordinate] = nil
            self[kingCoordinate] = nil
        } else if move.options.contains(.queenCastling) {
            let queenSideRookCoordinate: BoardCoordinate = move.piece.side == .black ? "e8" : "e1"
            let queenCoordinate: BoardCoordinate = move.piece.side == .black ? "d8" : "d1"
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

    func compareCells(cellA: BoardCell, type: PieceType, side: Side) -> Bool {
        guard let pieceA = cellA.piece else {
            return false
        }

        return pieceA.type == type && pieceA.side == side
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
            current = current.move(by: direction.sideRelativeDirection(side), side: side)
            
            if current == destination {
                return true
            }
            
            if self[current] != nil && !canMoveOver {
                return false
            }
        }
        
        return true
    }

    func getSourceDestination(side: Side, move: Move) throws -> BoardCoordinate {
        let piece = move.piece
        let destination = move.destination
        let isCapture = move.options.contains(.capture)
        let pieces = getPieces(of: piece.type, side: side)

        for piece in pieces {
            let sourceCoordinate = getCoordinate(of: piece)
            let delta = destination - sourceCoordinate
            
            let validPattern = piece.validPattern(delta: delta, side: side, isCapture: isCapture)
            
            if sourceCoordinate.rank == 5 && piece.type == .pawn && isCapture && self[move.destination] == nil {
                move.options.append(.enPassant)
                move.source = sourceCoordinate
                return sourceCoordinate
            }

            guard validPattern.directions.count > 0 else {
                continue
            }
            
            guard tryMovingToSource(source: sourceCoordinate, destination: destination, movePattern: validPattern, canMoveOver: piece.type == .knight, side: side) else {
                continue
            }

            var currentCoordinate = sourceCoordinate
            for direction in validPattern.directions {
                currentCoordinate = currentCoordinate.move(by: direction.sideRelativeDirection(side), side: side)

                if currentCoordinate == destination {
                    // Disambiguate between two pieces when an extra file is provided (like Rdd1).
                    // If two rooks can move to the same cell (say d1), then the extra d (between R and d1)
                    // must be specified. Therefore we check if the rank is nil and the source is not nil.
                    // If this is the case, the move source file and the file of the potential source coordiante
                    // must be the same, otherwise we'll pick the wrong piece.
                    if move.source?.rank == nil && move.source?.file != nil {
                        if move.source?.file != sourceCoordinate.file {
                            continue
                        }
                    }
                    move.source = sourceCoordinate
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
