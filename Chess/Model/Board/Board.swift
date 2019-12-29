//
//  Board.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

struct Board {
    private var cells: [[BoardCell]] = []
    
    init() {
        for rank in Rank.validRanks {
            var rankCells: [BoardCell] = []
            
            for file in File.validFiles {
                rankCells.append(.init(coordinate: .init(file: file, rank: rank), piece: nil))
            }
            
            cells.append(rankCells)
        }
        
        resetBoard()
    }
    
    subscript(coordinate: BoardCoordinate) -> Piece? {
        get {
            assert(isValidPlacement(rank: coordinate.rank, file: coordinate.file), "Index out of range")
            return cells[coordinate.rank - 1][coordinate.fileIndex].piece
        }
        set {
            assert(isValidPlacement(rank: coordinate.rank, file: coordinate.file), "Index out of range")
            cells[coordinate.rank - 1][coordinate.fileIndex].piece = newValue
        }
    }
    
    subscript(coordinate: BoardCoordinate, side: Side) -> Bool {
        return self[coordinate]?.side == side
    }
    
    mutating func performMove(_ move: MoveProtocol, on piece: inout Piece) {
        piece.moved = true
        self[move.destinationCoordinate] = piece
        self[move.sourceCoordinate] = nil
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
    
    func getSourceDestination(pieceName: Character?, destination: BoardCoordinate, side: Side) throws -> BoardCoordinate {
        let _piece = PieceFabric.create(pieceName)
        
        let pieces = getPieces(of: _piece.type, side: side)
        
        for piece in pieces {
            let sourceCoordinate = getCoordinate(of: piece)
            let delta = sourceCoordinate.difference(from: destination)
            let validPattern = piece.validPattern(delta: delta, side: side)
            
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
        
        throw GameError.invalidMove(message: "No valid source position for destination position.")
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
    
    func moveMultipleSteps(source: BoardCoordinate, destination: BoardCoordinate, direction: Direction, moves: Int, side: Side, canCrossOver: Bool = true) throws {
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
        
        if self[destination, side] {
            throw GameError.invalidMove(message: "Cannot move to position occupied by self")
        }
    }
    
    mutating func resetBoard() {
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
            self[BoardCoordinate(file: file, rank: 8)] = blackBackRank[index]
            self[BoardCoordinate(file: file, rank: 7)] = blackSecondRank[index]
            
            self[BoardCoordinate(file: file, rank: 2)] = whiteSecondRank[index]
            self[BoardCoordinate(file: file, rank: 1)] = whiteBackRank[index]
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

private extension Board {
    func isValidPlacement(rank: Int, file: String) -> Bool {
        isValidNumericalIndex(index: rank) && isValidFile(file)
    }
    
    func isValidNumericalIndex(index: Int) -> Bool {
        Rank.validRanks ~= index
    }
    
    func isValidFile(_ file: String) -> Bool {
        File.validFiles.contains(file.lowercased())
    }
}
