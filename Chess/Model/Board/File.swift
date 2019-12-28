//
//  File.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

typealias File = String

extension File {
    static var validFiles = ["a", "b", "c", "d", "e", "f", "g", "h"]
    
    var fileIndex: Int {
        File.validFiles.firstIndex(of: self) ?? 0
    }
    
    func difference(from file: File) -> Int {
        let destinationIndex = File.validFiles.firstIndex(of: file)!
        let sourceIndex = File.validFiles.firstIndex(of: self)!
        
        return destinationIndex - sourceIndex
    }
}
