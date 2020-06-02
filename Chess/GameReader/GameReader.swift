//
//  GameReader.swift
//  Chess
//
//  Created by Eirik Vale Aase on 02/06/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

import Foundation

protocol GameReader {
    static func read(textRepresentation: String) -> [Move]
}

struct PGNGameReader: GameReader {
    static func read(textRepresentation: String) -> [Move] {
        let potentialMoves = textRepresentation.split(separator: " ")
        let cleanMoves = potentialMoves.map { $0.replacingOccurrences(of: "\n", with: " ") }
        let validMoves = cleanMoves.filter { SANMoveFormatValidator().validate($0) }
        let moves = validMoves.compactMap { try? SANMoveInterpreter().interpret($0) }
        
        return moves
    }
}
