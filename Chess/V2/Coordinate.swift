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
struct Coordinate: Equatable, CustomStringConvertible, ExpressibleByStringLiteral {
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
    
    init(stringLiteral value: String) {
        let rawFile = String(value.first!)
        let rawRank = Int(String(value.last!))!
        
        self.file = File(value: rawFile)
        self.rank = Rank(value: rawRank)
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
        // let file = self.file + direction
        // let rank = self.rank + direction
        var file = self.file
        var rank = self.rank
        
        switch direction {
        case .north,
             .south: file = file + direction
        case .east,
             .west: rank = rank + direction
        case .northWest,
             .northEast,
             .southWest,
             .southEast:
            file = file + direction
            rank = rank + direction
        }
        
        return Coordinate(file: file, rank: rank)
    }
    
    /**
     Get the move pattern between this coordinate to another coordinate given the type of move that is to be performed.
     - Parameters:
        - coordinate: Destination coordinate
        - moveType: Type of move (straight, diagonal, et cetera)
     - Returns: The possible move pattern
     */
    func getMovePattern(to coordinate: Coordinate, with moveType: MoveType) -> MovePattern? {
        let sourceFileIndex = self.file.index
        let sourceRankIndex = self.rank.value - 1 // to make it zero-indexed
        
        let destinationFileIndex = coordinate.file.index
        let destinationRankIndex = coordinate.rank.value - 1
        
        let deltaX = destinationFileIndex - sourceFileIndex
        let deltaY = destinationRankIndex - sourceRankIndex
        
        let direction: Direction
        
        switch (deltaX, deltaY) {
        case (1..., 0): direction = .east
        case (...(-1), 0): direction = .west
        case (0, 1...): direction = .north
        case (0, ...(-1)): direction = .south
        default: return nil
        }
        
        let count = max(abs(deltaX), abs(deltaY))
        
        let directions = Array(repeating: direction, count: count)
        
        return .init(moveType: moveType, directions: directions)
    }
}
