//
//  main.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

//try RealGameExecutor(moveFormatValidator: SANMoveFormatValidator()).play()
let file = try PGNGameReader.readFile("twic920")
