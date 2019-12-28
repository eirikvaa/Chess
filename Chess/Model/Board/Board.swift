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
