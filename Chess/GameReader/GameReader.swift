//
//  GameReader.swift
//  Chess
//
//  Created by Eirik Vale Aase on 02/06/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

import Foundation

enum GameReaderError: Error {
    case missingGameFile
    case invalidGameFormat
}

protocol GameReader {
    static func read(textRepresentation: String) -> [Move]
}

struct PGNGameReader: GameReader {
    static func read(textRepresentation: String) -> [Move] {
        let moves = textRepresentation
            .replacingOccurrences(of: "\n", with: " ")
            .split(separator: " ")
            .filter { SANMoveFormatValidator().validate(String($0)) }
            .compactMap { try? SANMoveInterpreter().interpret(String($0)) }

        return moves
    }

    /**
     Read in a single PGN file. For instance, the files from This Week In Chess (twic)
     may contain over 2000 games. Read in one of these files and return a list of list of
     strings.
     
     The PGN files are on the following format:
     [ meta information ]
     [ meta information ]
     ...
     [ meta information ]
     
     1. e4 d6 2. ...
     
     [ meta information ]
     ...
     */
    static func readFile(_ file: String) throws -> [String] {
        // Hack to get around the resource files not being correctly
        // copied to the main bundle of the test target. We have to look inside
        // all bundles for the existence of the file.
        let possibleFiles = Bundle.allBundles.compactMap {
            $0.url(forResource: file, withExtension: "pgn")
        }

        guard let pgnFile = possibleFiles.first else {
            throw GameReaderError.missingGameFile
        }

        let contents = try String(contentsOf: pgnFile, encoding: .utf8)

        var games: [String] = []
        var currentGame = ""
        for line in contents.split(separator: "\n") {
            if line.first == "[" {
                if !currentGame.isEmpty {
                    games.append(currentGame)
                    currentGame = ""
                }
                continue
            }

            currentGame += line + " "
        }

        return games
    }
}
