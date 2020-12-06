//
//  Coordinate.swift
//  Chess
//
//  Created by Eirik Vale Aase on 05/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

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
