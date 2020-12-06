//
//  String+Ext.swift
//  Chess
//
//  Created by Eirik Vale Aase on 05/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

extension String {
    /**
     Remove the suffix of length `count` from the string and return both it and the rest of the string.
     If the length of the string is equal to or less than the suffix asked for, return everything as the suffix
     and nothing as the rest.
     */
    mutating func removeSuffix(count: Int) -> (suffix: String, rest: String) {
        guard self.count > count else {
            return (self, "")
        }
        
        var chars: [String] = []
        
        for _ in 0..<count {
            let lastCharacter = removeLast()
            chars.insert(String(lastCharacter), at: 0)
        }
        
        return (chars.joined(), self)
    }
}
