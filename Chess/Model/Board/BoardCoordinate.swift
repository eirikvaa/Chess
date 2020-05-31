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
        File.validFiles.firstIndex(of: file?.file ?? "a") ?? 0
    }

    func fileIndexToFile(_ index: Int) -> File {
        return File.init(stringLiteral: File.validFiles[index])
    }

    func difference(from coordinate: BoardCoordinate) -> Delta {
        let deltaX = file?.difference(from: coordinate.file ?? "a")
        let deltaY = (coordinate.rank?.rank ?? 1) - (rank?.rank ?? 1)
        return .init(x: deltaX!, y: deltaY)
    }

    func move(by delta: Delta) -> BoardCoordinate {
        let newFile = fileIndexToFile(file!.fileIndex + delta.x)
        return .init(file: newFile, rank: rank! + delta.y)
    }
    
    static func == (lhs: BoardCoordinate, rhs: BoardCoordinate) -> Bool {
        (lhs.file, lhs.rank) == (rhs.file, rhs.rank)
    }
}

extension BoardCoordinate: ExpressibleByStringInterpolation {}

extension BoardCoordinate {
    mutating func move(by direction: Direction, side: Side) -> BoardCoordinate {
        let delta = Delta(x: 0, y: 0).advance(by: direction) * side.sideMultiplier
        return move(by: delta)
    }
}

extension BoardCoordinate: CustomStringConvertible {
    var description: String {
        "\(file)\(rank)"
    }
}
