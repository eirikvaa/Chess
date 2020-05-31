//
//  File.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

struct File: ExpressibleByStringLiteral, Comparable {
    var file = "a"
    
    static var validFiles = ["a", "b", "c", "d", "e", "f", "g", "h"]
    
    init(stringLiteral value: String) {
        self.file = value
    }
    
    var fileIndex: Int {
        File.validFiles.firstIndex(of: self.file) ?? 0
    }

    func difference(from file: File) -> Int {
        let destinationIndex = File.validFiles.firstIndex(of: file.file)!
        let sourceIndex = File.validFiles.firstIndex(of: self.file)!

        return destinationIndex - sourceIndex
    }
    
    static func == (lhs: File, rhs: File) -> Bool {
        lhs.file == rhs.file
    }
    
    static func < (lhs: File, rhs: File) -> Bool {
        lhs.file < rhs.file
    }
}
