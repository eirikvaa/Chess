//
//  Pawn.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//

import Foundation

/// Pawns are the least valuable pieces on the board. Their move patterns depend on the state
/// at which they are in, specifically if they have moved or not from before. If they have not moved yet,
/// they can move ahead two cells. If not, they can only move one cell.
class Pawn: Piece, Identifiable {
    let id = UUID()
    var content: String {
        side == .white ? "♙" : "♟"
    }
    let type: PieceType = .pawn
    let side: Side
    var hasMoved = false
    let canMoveOverOtherPieces = false
    var movePatterns: [MovePattern] {
        switch (hasMoved, side) {
        case (false, .white):
            return [
                .single(.north),
                .double(.north, .north),
                .single(.northWest),
                .single(.northEast)
            ]
        case (true, .white):
            return [
                .single(.north),
                .single(.northWest),
                .single(.northEast)
            ]
        case (false, .black):
            return [
                .single(.south),
                .double(.south, .south),
                .single(.southWest),
                .single(.southEast)
            ]
        case (true, .black):
            return [
                .single(.south),
                .single(.southWest),
                .single(.southEast)
            ]
        }
    }

    var validCaptureDirections: [Direction] {
        switch side {
        case .white: return [.northWest, .northEast]
        case .black: return [.southWest, .southEast]
        }
    }

    var validNonCaptureDirections: [Direction] {
        switch side {
        case .white: return [.north]
        case .black: return [.south]
        }
    }

    required init(side: Side) {
        self.side = side
    }

    var desc: String {
        "P" + content
    }
}
