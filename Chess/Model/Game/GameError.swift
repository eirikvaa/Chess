//
//  GameError.swift
//  Chess
//
//  Created by Eirik Vale Aase on 27/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

extension GameState {
    enum GameStateError: Error {
        case illegalMove
        case noValidSourcePieces
        case ambiguousMove
        case cannotMovePieceOfOppositeSide
        case destinationIsOccupiedByOwnPiece
        case cannotPerformCaptureWithoutNotingItInMove
    }
}
