//
//  Move.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

struct Move {
    let sourceCoordinate: BoardCoordinate
    let destinationCoordinate: BoardCoordinate
    
    init?(move: String) throws {
        guard let _ = move.lowercased().range(
            of: #"[a-h][1-8][a-h][1-8]"#,
            options: .regularExpression) else {
            throw GameError.invalidMoveFormat
        }
        
        let characters = Array(move).map { String($0) }
        
        sourceCoordinate = BoardCoordinate(
            file: characters[0],
            row: Int(characters[1])!)
        destinationCoordinate = BoardCoordinate(
            file: characters[2],
            row: Int(characters[3])!)
    }
}

extension Move: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self = try! Move(move: value)!
    }
}
