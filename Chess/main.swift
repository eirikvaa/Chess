//
//  main.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

// let game2 = Game()

// try game2.play()

let games = try PGNGameReader.readFile("twic920")
let moves = PGNGameReader.read(textRepresentation: games[1])

print(moves)

let game = Game()

try game.applyMoves(moves)
