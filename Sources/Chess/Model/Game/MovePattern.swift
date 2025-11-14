//
//  MovePattern.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//

enum MovePattern {
    /// Pawn: Single move and capture
    /// King
    case single(Direction)

    /// Pawn: Double move (possible initial move)
    case double(Direction, Direction)

    /// Knight
    case shape(Direction, Direction, Direction)

    /// Queen
    /// Bishop
    /// Rook
    case continuous(Direction)
}
