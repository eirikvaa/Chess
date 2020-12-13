//
//  File.swift
//  Chess
//
//  Created by Eirik Vale Aase on 06/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

import Foundation

/**
 A file is a (vertical) column as seen from white's perspective.
 Goes from "a" to "h" from left to right.
 */
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

    static func + (lhs: File, rhs: Direction) -> File? {
        guard let lhsIndex: Int = validFiles.firstIndex(of: lhs.value) else {
            fatalError("Cannot find index of \(lhs.value), this should be impossible.")
        }

        let deltaX: Int

        switch rhs {
        case .east,
             .northEast,
             .southEast: deltaX = 1
        case .west,
             .northWest,
             .southWest: deltaX = -1
        default: deltaX = 0
        }

        let newIndex = lhsIndex + deltaX
        guard 0..<validFiles.count ~= newIndex else {
            return nil
        }

        return File(stringLiteral: validFiles[newIndex])
    }

    var description: String {
        value
    }
}
