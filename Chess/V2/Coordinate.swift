//
//  Coordinate.swift
//  Chess
//
//  Created by Eirik Vale Aase on 05/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

struct File: Equatable, CustomStringConvertible, ExpressibleByStringLiteral {
    let value: String
    static var validFiles = ["a", "b", "c", "d", "e", "f", "g", "h"]
    var index: Int {
        let validFiles = ["a", "b", "c", "d", "e", "f", "g", "h"]
        return validFiles.firstIndex(of: value)!
    }
    
    init(stringLiteral value: String) {
        self.value = value
    }
    
    init(value: String) {
        self.value = value
    }
    
    static func == (lhs: File, rhs: File) -> Bool {
        lhs.value == rhs.value
    }
    
    static func + (lhs: File, rhs: Direction) -> File {
        guard let lhsIndex: Int = validFiles.firstIndex(of: lhs.value) else {
            fatalError("Cannot find index of \(lhs.value), this should be impossible.")
        }
        
        let deltaX: Int
        
        switch rhs {
        case .east: deltaX = 1
        case .west: deltaX = -1
        default: deltaX = 0
        }
        
        let newIndex = lhsIndex + deltaX
        guard newIndex < validFiles.count else {
            fatalError("Index \(newIndex) is invalid.")
        }
        
        return File(stringLiteral: validFiles[newIndex])
    }
    
    var description: String {
        value
    }
}

struct Rank: Equatable, CustomStringConvertible, ExpressibleByIntegerLiteral {
    let value: Int
    
    init(integerLiteral value: Int) {
        self.value = value
    }
    
    init(value: Int) {
        self.value = value
    }
    
    static func == (lhs: Rank, rhs: Rank) -> Bool {
        lhs.value == rhs.value
    }
    
    static func + (lhs: Rank, rhs: Direction) -> Rank {
        let deltaY: Int
        switch rhs {
        case .north: deltaY = 1
        case .south: deltaY = -1
        default: deltaY = 0
        }
        
        let newIndex = lhs.value + deltaY
        
        guard 1...8 ~= newIndex else {
            fatalError("Rank \(newIndex) is impossible to attain.")
        }
        
        return Rank(value: newIndex)
    }
    
    var description: String {
        "\(value)"
    }
}

/**
 A coordinate that can take any of the coordinate combination in the set ["a", "b", "c", "d", "e", "f", "g", "h"] X 1...8.
 */
struct Coordinate: Equatable, CustomStringConvertible {
    enum CoordinateValidationError: Error {
        case invalidFile
        case invalidRank
    }
    
    /// A column on the board as seen from white's perspective.
    /// Goes from "a" to "h" from left to right.
    let file: File
    
    /// A row on the board as seen from white's perspective.
    /// Goes from 1 - 8 from nearest to farthest.
    let rank: Rank
    
    init(rawCoordinates: String) throws {
        let file = String(rawCoordinates.dropLast())
        
        guard "a"..."h" ~= file else {
            throw CoordinateValidationError.invalidFile
        }
        
        guard let rank = Int(rawCoordinates.dropFirst()), 1...8 ~= rank else {
            throw CoordinateValidationError.invalidRank
        }
        
        self.file = File(value: file)
        self.rank = Rank(value: rank)
    }
    
    init(file: File, rank: Rank) {
        self.file = file
        self.rank = rank
    }
    
    var description: String {
        "\(file)\(rank)"
    }
    
    /**
     Apply a direction to a given coordinate and produce a new coordinate.
     - Parameters direction: The direction to apply
     - Returns: A new coordinate
     */
    func applyDirection(_ direction: Direction) -> Coordinate {
        let file = self.file + direction
        let rank = self.rank + direction
        
        return Coordinate(file: file, rank: rank)
    }
}
