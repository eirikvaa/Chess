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
        let moves = textRepresentation
            .replacingOccurrences(of: "\n", with: " ")
            .split(separator: " ")
            .filter { SANMoveFormatValidator().validate(String($0)) }
            .compactMap { try? SANMoveInterpreter().interpret(String($0)) }
        
        return moves
    }
}
