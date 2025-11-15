//
//  GameReader.swift
//  Chess
//
//  Created by Eirik Vale Aase on 02/06/2020.
//

import Foundation

enum GameReaderError: Error {
    case missingGameFile
    case invalidGameFormat
}

protocol GameReader {
    static func read(textRepresentation: String) -> [String]
}

struct PGNGameReader: GameReader {
    static func read(textRepresentation: String) -> [String] {
        let moves = textRepresentation
            .replacingOccurrences(of: "\n", with: " ")
            .split(separator: " ")
            .compactMap { try? Move(rawMove: String($0)) }
            .map { $0.rawMove }

        return moves
    }

    /// Read in a single PGN file. For instance, the files from This Week In Chess (twic)
    /// may contain over 2000 games. Read in one of these files and return a list of list of
    /// strings.
    ///
    /// The PGN files are on the following format:
    /// [ meta information ]
    /// [ meta information ]
    /// ...
    /// [ meta information ]
    ///
    /// 1. e4 d6 2. ...
    ///
    /// [ meta information ]
    /// ...
    static func readFile(_ file: String) throws -> [String] {
        let pgnFile = Bundle.module.url(forResource: file, withExtension: "pgn")

        guard let pgnFile else {
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
