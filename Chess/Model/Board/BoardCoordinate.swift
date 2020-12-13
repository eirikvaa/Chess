//
//  BoardCoordinate.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

/**
 BoardCoordinates are used for expressing coordinates on a chess board.
 A BoardCooardinate is made up of the *file* and the *rank*.
 The file is a letter from A to H (inclusive) and the rank is a digit from 1 to 8 (inclusive).
 Files can be considered the *columns* and ranks the *rows*.
*/
struct BoardCoordinate: ExpressibleByStringLiteral, Equatable {
    var file: File?
    var rank: Rank?

    var isValid: Bool {
        guard let file = file, let rank = rank else {
            return false
        }

        return FileValidator.validate(file) && RankValidator.validate(rank)
    }

    init(file: File?, rank: Rank?) {
        self.file = file
        self.rank = rank
    }

    init(stringLiteral value: String) {
        let file = File(stringLiteral: String(value.dropLast()))
        let rank = Rank(integerLiteral: value.last?.wholeNumberValue ?? 1)
        self = BoardCoordinate(file: file, rank: rank)
    }

    var fileIndex: Int {
        file?.fileIndex ?? 0
    }

    static func == (lhs: BoardCoordinate, rhs: BoardCoordinate) -> Bool {
        (lhs.file, lhs.rank) == (rhs.file, rhs.rank)
    }

    static func - (lhs: BoardCoordinate, rhs: BoardCoordinate) -> Delta {
        let deltaX = lhs.fileIndex - rhs.fileIndex
        let deltaY = (lhs.rank?.rank ?? 1) - (rhs.rank?.rank ?? 1)
        return .init(x: deltaX, y: deltaY)
    }

    mutating func move(by direction: Direction, side: Side) -> BoardCoordinate {
        let delta = Delta(x: 0, y: 0).advance(by: direction)
        let newFile = File(fileIndex: file!.fileIndex + delta.x)
        return .init(file: newFile, rank: rank! + delta.y)
    }
}

extension BoardCoordinate: CustomStringConvertible {
    var description: String {
        let source = file ?? File(stringLiteral: "")
        let destination = rank ?? Rank(integerLiteral: 0)
        return "\((source, destination))"
    }
}
