//
//  BoardCoordinate.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

struct BoardCoordinate {
    @Clamping("a" ... "h")
    var file: File = "a"
    
    @Clamping(Rank.validRanks)
    var rank: Rank = 1
    
    var fileIndex: Int {
        File.validFiles.firstIndex(of: file) ?? 0
    }
    
    func fileIndexToFile(_ index: Int) -> File {
        File.validFiles[index]
    }
    
    func difference(from coordinate: BoardCoordinate) -> Delta {
        let deltaX = file.difference(from: coordinate.file)
        let deltaY = coordinate.rank - rank
        return .init(x: deltaX, y: deltaY)
    }
    
    func move(by delta: Delta) -> BoardCoordinate {
        let newFile = fileIndexToFile(file.fileIndex + delta.x)
        return .init(file: newFile, rank: rank + delta.y)
    }
}

extension BoardCoordinate: Equatable {
    static func == (lhs: BoardCoordinate, rhs: BoardCoordinate) -> Bool {
        lhs.file == rhs.file && lhs.rank == rhs.rank
    }
}

extension BoardCoordinate: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        let file = String(value.dropLast())
        let rank = Int(String(value.dropFirst()))!
        self = .init(file: file, rank: rank)
    }
}

extension BoardCoordinate {
    mutating func move(by direction: Direction, side: Side) -> BoardCoordinate {
        let delta = Delta(x: 0, y: 0).advance(by: direction) * side.sideMultiplier
        return self.move(by: delta)
    }
}
