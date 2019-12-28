//
//  Board.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

struct Board {
    private let validRows = 1 ... 8
    private var cells: [[BoardCell]] = []
    
    init() {
        for row in validRows {
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
        validRows ~= index
    }
    
    func isValidFile(_ file: String) -> Bool {
        File.validFiles.contains(file.lowercased())
    }
}
