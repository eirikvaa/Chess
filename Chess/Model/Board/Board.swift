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
        for row in Row.validRows {
            var rowPositions: [BoardCell] = []
            
            for file in File.validFiles {
                rowPositions.append(.init(coordinate: .init(file: file, row: row), piece: nil))
            }
            
            cells.append(rowPositions)
        }
    }
    
    subscript(coordinate: BoardCoordinate) -> Piece? {
        get {
            assert(isValidPlacement(row: coordinate.row, file: coordinate.file), "Index out of range")
            return cells[coordinate.row - 1][coordinate.fileIndex].piece
        }
        set {
            assert(isValidPlacement(row: coordinate.row, file: coordinate.file), "Index out of range")
            cells[coordinate.row - 1][coordinate.fileIndex].piece = newValue
        }
    }
    
    subscript(coordinate: BoardCoordinate, side: Side) -> Bool {
        return self[coordinate]?.player?.side == side
    }
    
    mutating func performMove(_ move: Move, on piece: inout Piece) {
        piece.moved = true
        self[move.destinationCoordinate] = piece
        self[move.sourceCoordinate] = nil
    }
    
    func canAttack(at coordinate: BoardCoordinate, side: Side) -> Bool {
        guard let otherPiece = self[coordinate] else {
            return false
        }
        
        guard otherPiece.player?.side != side else {
            return false
        }
        
        return true
    }
    
    func moveMultipleSteps(source: BoardCoordinate, destination: BoardCoordinate, direction: Direction, moves: Int, side: Side, canCrossOver: Bool = true) throws {
        var currentCoordinate = source
        
        for _ in 0 ..< moves {
            currentCoordinate = currentCoordinate.move(by: direction, side: side)
            
            if currentCoordinate == destination {
                break
            }
            
            guard let otherPieceInCurrentPosition = self[currentCoordinate] else {
                continue
            }
            
            if otherPieceInCurrentPosition.player?.side != side, !canCrossOver {
                throw GameError.invalidMove(message: "Cannot move over opposite piece")
            }
        }
        
        if self[destination, side] {
            throw GameError.invalidMove(message: "Cannot move to position occupied by self")
        }
    }
}

extension Board: CustomStringConvertible {
    var description: String {
        var _description = "    a   b   c   d   e   f   g   h\n"
        _description += "   ––– ––– ––– ––– ––– ––– ––– ––– \n"
        
        for (index, row) in cells.reversed().enumerated() {
            _description += "\(8 - index) |"
            
            for cell in row {
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
    func isValidPlacement(row: Int, file: String) -> Bool {
        isValidNumericalIndex(index: row) && isValidFile(file)
    }
    
    func isValidNumericalIndex(index: Int) -> Bool {
        Row.validRows ~= index
    }
    
    func isValidFile(_ file: String) -> Bool {
        File.validFiles.contains(file.lowercased())
    }
}
