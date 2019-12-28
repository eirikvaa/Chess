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
    
    @Clamping(Row.validRows)
    var row: Row = 1
    
    var fileIndex: Int {
        File.validFiles.firstIndex(of: file) ?? 0
    }
    
    func fileIndexToFile(_ index: Int) -> File {
        File.validFiles[index]
    }
}

extension BoardCoordinate: Equatable {
    static func == (lhs: BoardCoordinate, rhs: BoardCoordinate) -> Bool {
        lhs.file == rhs.file && lhs.row == rhs.row
    }
}

extension BoardCoordinate: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        let file = String(value.dropLast())
        let row = Int(String(value.dropFirst()))!
        self = .init(file: file, row: row)
    }
}

extension BoardCoordinate {
    mutating func move(by direction: Direction, side: Side) -> BoardCoordinate {
        let delta = Delta(x: 0, y: 0).advance(by: direction)
        
        var fileIndexDelta = delta.x
        var rowDelta = delta.y
        
        fileIndexDelta *= side.sideMultiplier
        rowDelta *= side.sideMultiplier
        
        return .init(file: fileIndexToFile(fileIndex + fileIndexDelta), row: row + rowDelta)
    }
}
