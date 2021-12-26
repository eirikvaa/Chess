//
//  Coordinate.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

/// A coordinate that can take any of the coordinate combination
/// in the set ["a", "b", "c", "d", "e", "f", "g", "h"] X 1...8.
struct Coordinate: Equatable, CustomStringConvertible, ExpressibleByStringLiteral {
    enum CoordinateValidationError: Error {
        case invalidFile
        case invalidRank
    }

    /// A column on the board as seen from white's perspective.
    /// Goes from "a" to "h" from left to right.
    let file: File?

    /// A row on the board as seen from white's perspective.
    /// Goes from 1 - 8 from nearest to farthest.
    let rank: Rank?

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

    init(file: File?, rank: Rank?) {
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
        "\(file ?? "")\(rank ?? 0)"
    }

    /// Apply a direction to a given coordinate and produce a new coordinate.
    /// - parameters direction: The direction to apply
    /// - returns: A new coordinate
    func applyDirection(_ direction: Direction) -> Coordinate? {
        var tmpFile: File? = self.file
        var tmpRank: Rank? = self.rank

        switch direction {
        case .north,
             .south: tmpRank = tmpRank! + direction
        case .east,
             .west: tmpFile = tmpFile! + direction
        case .northWest,
             .northEast,
             .southWest,
             .southEast:
            tmpFile = tmpFile! + direction
            tmpRank = tmpRank! + direction
        }

        guard let file = tmpFile, let rank = tmpRank else {
            return nil
        }

        return Coordinate(file: file, rank: rank)
    }
}
