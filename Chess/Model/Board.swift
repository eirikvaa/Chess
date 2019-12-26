//
//  Board.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

struct Board {
    let validRows = 0 ..< 8
    let validColumns = ["a", "b", "c", "d", "e", "f", "g", "h"]
    private var pieces: [Piece?] = Array(repeating: nil, count: 64)
    
    subscript(row: Int, column: String) -> Piece? {
        get {
            assert(isValidPlacement(row: row, column: column), "Index out of range")
            let column = characterToColumn(column)
            return pieces[row * 8 + column]
        }
        set {
            assert(isValidPlacement(row: row, column: column), "Index out of range")
            let column = characterToColumn(column)
            pieces[row * 8 + column] = newValue
        }
    }
}

extension Board: CustomStringConvertible {
    var description: String {
        var _description = " ––– ––– ––– ––– ––– ––– ––– ––– \n"
        
        for row in validRows {
            _description += "|"
            for column in validColumns {
                let piece = self[row, column]
                _description += " " + (piece?.graphicalRepresentation ?? " ") + "\t|"
            }
            _description += "\n ––– ––– ––– ––– ––– ––– ––– ––– \n"
        }
        
        return _description
    }
}

private extension Board {
    func characterToColumn(_ columnCharacter: String) -> Int {
        let columnCharacter = columnCharacter.lowercased()
        let columnCharacters = ["a", "b", "c", "d", "e", "f", "g", "h"]
        return columnCharacters.firstIndex(of: columnCharacter) ?? 0
    }
    
    func isValidPlacement(row: Int, column: String) -> Bool {
        isValidNumericalIndex(index: row) && isValidColumnCharacter(column)
    }
    
    func isValidNumericalIndex(index: Int) -> Bool {
        validRows ~= index
    }
    
    func isValidColumnCharacter(_ column: String) -> Bool {
        validColumns.contains(column.lowercased())
    }
}
