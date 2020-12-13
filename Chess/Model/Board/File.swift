//
//  File.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

struct File: ExpressibleByStringLiteral, Comparable, CustomStringConvertible {
    var file = "a"

    static var validFiles = ["a", "b", "c", "d", "e", "f", "g", "h"]

    init(stringLiteral value: String) {
        self.file = value
    }

    init(fileIndex: Int) {
        guard 0 ... 7 ~= fileIndex else {
            self.file = "a"
            return
        }

        self.file = File.validFiles[fileIndex]
    }

    var fileIndex: Int {
        File.validFiles.firstIndex(of: self.file) ?? 0
    }

    static func == (lhs: File, rhs: File) -> Bool {
        lhs.file == rhs.file
    }

    static func < (lhs: File, rhs: File) -> Bool {
        lhs.file < rhs.file
    }

    static func - (lhs: File, rhs: File) -> File {
        let validFiles = File.validFiles
        let difference = rhs.fileIndex - lhs.fileIndex

        assert(0 ... 7 ~= difference, "\(difference + 1) is not a valid file index.")
        return File(stringLiteral: validFiles[difference])
    }

    var description: String {
        file
    }
}
