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
    let validFiles = ["a", "b", "c", "d", "e", "f", "g", "h"]
    private var pieces: [Piece?] = Array(repeating: nil, count: 64)
    
    subscript(file: String, row: Int) -> Piece? {
        get {
            assert(isValidPlacement(row: row, file: file), "Index out of range")
            let file = fileToIndex(file)
            return pieces[row * 8 + file]
        }
        set {
            assert(isValidPlacement(row: row, file: file), "Index out of range")
            let file = fileToIndex(file)
            pieces[row * 8 + file] = newValue
        }
    }
    
    subscript(index: Int) -> Piece? {
        get {
            pieces[index]
        }
        set {
            pieces[index] = newValue
        }
    }
    
    subscript(fileRowString: String, fileDelta: Int, rowDelta: Int, side: Side, direction: Direction) -> Piece? {
        let verticalMultiplier = direction == .north ? 1 : -1
        let horizontalMultiplier = direction == .east ? 1 : -1
        var index = boardIndex(fileRowString: fileRowString)
        index += fileDelta * side.sideMultiplier * verticalMultiplier
        index += rowDelta * 8 * side.sideMultiplier * horizontalMultiplier
        return self[index]
    }
    
    subscript(fileRowString: String) -> Piece? {
        get {
            self[boardIndex(fileRowString: fileRowString)]
        }
        set {
            self[boardIndex(fileRowString: fileRowString)] = newValue
        }
    }
    
    func boardIndex(fileRowString: String) -> Int {
        let file = String(fileRowString.dropLast())
        let row = Int(String(fileRowString.dropFirst()))!
        return 63 - row * 8 + fileToIndex(file) + 1
    }
}

extension Board: CustomStringConvertible {
    var description: String {
        var _description = "    a   b   c   d   e   f   g   h\n"
        _description += "   ––– ––– ––– ––– ––– ––– ––– ––– \n"
        
        for row in validRows {
            _description += "\(abs(row - 7) + 1) |"
            for file in validFiles {
                let piece = self[file, row]
                _description += " " + (piece?.graphicalRepresentation ?? " ") + " |"
            }
            _description += " \(abs(row - 7) + 1)\n   ––– ––– ––– ––– ––– ––– ––– ––– \n"
        }
        
        _description += "    a   b   c   d   e   f   g   h\n"
        
        return _description
    }
}

private extension Board {
    func fileToIndex(_ file: String) -> Int {
        let files = ["a", "b", "c", "d", "e", "f", "g", "h"]
        return files.firstIndex(of: file.lowercased()) ?? 0
    }
    
    func distanceBetweenFiles(sourceFile: String, destinationFile: String) -> Int {
        let sourceFileIndex = fileToIndex(sourceFile)
        let destinationFileIndex = fileToIndex(destinationFile)
        
        return destinationFileIndex - sourceFileIndex
    }
    
    func isValidPlacement(row: Int, file: String) -> Bool {
        isValidNumericalIndex(index: row) && isValidFile(file)
    }
    
    func isValidNumericalIndex(index: Int) -> Bool {
        validRows ~= index
    }
    
    func isValidFile(_ file: String) -> Bool {
        validFiles.contains(file.lowercased())
    }
}
