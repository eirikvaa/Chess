//
//  String+Ext.swift
//  Chess
//
//  Created by Eirik Vale Aase on 05/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

extension String {
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
