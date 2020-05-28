//
//  Validators.swift
//  Chess
//
//  Created by Eirik Vale Aase on 29/05/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

import Foundation

protocol Validator {
    associatedtype Element
    static func validate(_ element: Element) -> Bool
}

struct BoardCoordinateValidator: Validator {
    typealias Element = BoardCoordinate
    
    static func validate(_ element: BoardCoordinate) -> Bool {
        RankValidator.validate(element.rank) && FileValidator.validate(element.file)
    }
}

struct RankValidator: Validator {
    typealias Element = Rank
    
    static func validate(_ element: Rank) -> Bool {
        Rank.validRanks ~= element
    }
}

struct FileValidator: Validator {
    typealias Element = File
    
    static func validate(_ element: File) -> Bool {
        "a" ... "h" ~= element
    }
}
