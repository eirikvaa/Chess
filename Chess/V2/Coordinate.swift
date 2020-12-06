//
//  Coordinate.swift
//  Chess
//
//  Created by Eirik Vale Aase on 05/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

struct Coordinate: Equatable, CustomStringConvertible {
    enum CoordinateValidationError: Error {
        case invalidFile
        case invalidRank
    }
    
    let file: String
    let rank: Int
    
    init(rawCoordinates: String) throws {
        let file = String(rawCoordinates.dropLast())
        
        guard "a"..."h" ~= file else {
            throw CoordinateValidationError.invalidFile
        }
        
        guard let rank = Int(rawCoordinates.dropFirst()), 1...8 ~= rank else {
            throw CoordinateValidationError.invalidRank
        }
        
        self.file = file
        self.rank = rank
    }
    
    init(file: String, rank: Int) {
        self.file = file
        self.rank = rank
    }
    
    var description: String {
        "\(file)\(rank)"
    }
}
