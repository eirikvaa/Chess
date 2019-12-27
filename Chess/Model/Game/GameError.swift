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
}
