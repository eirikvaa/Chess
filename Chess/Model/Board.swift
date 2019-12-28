//
//  Board.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

@propertyWrapper
struct Clamping<Value: Comparable> {
    var value: Value
    let range: ClosedRange<Value>
    
    init(wrappedValue value: Value, _ range: ClosedRange<Value>) {
        self.value = value
        self.range = range
    }
    
    var wrappedValue: Value {
        get {
            value
        }
        set {
            value = min(max(value, range.lowerBound), range.upperBound)
        }
    }
}

typealias File = String
typealias Row = Int

struct BoardCell {
    let coordinate: BoardCoordinate
    var piece: Piece?
}

struct BoardCoordinate {
    @Clamping("a" ... "h")
    var file: File = "a"
    
    @Clamping(1 ... 8)
    var row: Row = 1
    
    var index: Int {
        return (row - 1) * 8 + fileIndex
    }
    
    var fileIndex: Int {
        ["a", "b", "c", "d", "e", "f", "g", "h"].firstIndex(of: file) ?? 0
    }
    
    func fileIndexToFile(_ index: Int) -> File {
        ["a", "b", "c", "d", "e", "f", "g", "h"][index]
    }
}

extension BoardCoordinate: Equatable {
    static func == (lhs: BoardCoordinate, rhs: BoardCoordinate) -> Bool {
        lhs.file == rhs.file && lhs.row == rhs.row
    }
}

extension BoardCoordinate: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        let file = String(value.dropLast())
        let row = Int(String(value.dropFirst()))!
        self = .init(file: file, row: row)
    }
}

extension BoardCoordinate {
    mutating func move(by direction: Direction, side: Side) -> BoardCoordinate {
        var fileIndexDelta = 0
        var rowDelta = 0
        
        switch direction {
        case .north: rowDelta += 1
        case .northEast: rowDelta += 1; fileIndexDelta += 1
        case .east: fileIndexDelta += 1
        case .southEast: fileIndexDelta += 1; rowDelta -= 1
        case .south: rowDelta -= 1
        case .southWest: fileIndexDelta -= 1; rowDelta -= 1
        case .west: fileIndexDelta -= 1
        case .northWest: rowDelta += 1; fileIndexDelta -= 1
        }
        
        fileIndexDelta *= side.sideMultiplier
        rowDelta *= side.sideMultiplier
        
        return .init(file: fileIndexToFile(fileIndex + fileIndexDelta), row: row + rowDelta)
    }
}

extension BoardCell: CustomStringConvertible {
    var description: String {
        return piece?.graphicalRepresentation ?? " "
    }
}

struct Board {
    let validFiles = ["a", "b", "c", "d", "e", "f", "g", "h"]
    
    private let validRows = 1 ... 8
    private var cells: [[BoardCell]] = []
    
    init() {
        for row in validRows {
            var rowPositions: [BoardCell] = []
            
            for file in validFiles {
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
    
    func fileToIndex(_ file: String) -> Int {
        return validFiles.firstIndex(of: file.lowercased()) ?? 0
    }
    
    func fileIndexToFile(_ index: Int) -> String {
        validFiles[index]
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
        validFiles.contains(file.lowercased())
    }
}
