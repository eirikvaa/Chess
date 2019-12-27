//
//  Move.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

struct Move {
    let source: String
    let destination: String
    
    var text: String {
        return source + destination
    }
    
    init?(move: String) throws {
        guard let _ = move.lowercased().range(of: #"[a-h][1-8][a-h][1-8]"#, options: .regularExpression) else {
            throw GameErrors.invalidMoveFormat
        }
        
        source = String(move.dropLast(2))
        destination = String(move.dropFirst(2))
    }
    
    func partition(moveComponent: String) -> (String, Int) {
        let file = String(moveComponent.dropLast())
        let row = Int(String(moveComponent.dropFirst()))!
        return (file, row)
    }
}

extension Move: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        self = try! Move(move: value)!
    }
}
