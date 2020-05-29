//
//  GameError.swift
//  Chess
//
//  Created by Eirik Vale Aase on 27/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

enum GameError: Error {
    case invalidMoveFormat
    case noPieceInSourcePosition
    case ownPieceInDestinationPosition
    case invalidPiece
    case invalidMove(message: String)
    
    func printErrorMessage() {
        switch self {
        case .invalidPiece:
            print("You cannot use the piece of an opponent.")
        case .ownPieceInDestinationPosition:
            print("You cannot move a piece to a position taken up by your own pieces.")
        case let .invalidMove(message):
            print(message)
        case .noPieceInSourcePosition:
            print("There is no piece in the source position you entered.")
        case .invalidMoveFormat:
            print("Move was on an invalid format.")
        }
    }
}
