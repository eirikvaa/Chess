//
//  GameError.swift
//  Chess
//
//  Created by Eirik Vale Aase on 27/12/2019.
//

extension GameState {
    enum GameStateError: Error {
        case illegalMove(message: String)
        case noValidSourcePieces(message: String)
        case ambiguousMove(message: String)
        case cannotMovePieceOfOppositeSide
        case destinationIsOccupiedByOwnPiece
        case mustMarkCaptureInMove
        case cannotCaptureOwnPiece
        case cannotMoveOverOtherPieces
    }
}
