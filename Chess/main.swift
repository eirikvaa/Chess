//
//  main.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

let game2 = Game()

try game2.play()

let games = try PGNGameReader.readFile("twic920")

for (index, game) in games[27...].enumerated() {
    print("STARTING GAME \(index + 27)")

    let moves = PGNGameReader.read(textRepresentation: game)
    do {
        try Game().applyMoves(moves)
    } catch let error as GameState.GameStateError {
        print(error)
        print(game)
        break
    }
}
