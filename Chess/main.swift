//
//  main.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

var game = Game(prePlayedMoves: ["e2e4", "e7e5", "g1f3", "b8c6", "f1b5"])
game.resetBoard()
try? game.startGame(continueAfterPrePlayedMoves: false)
