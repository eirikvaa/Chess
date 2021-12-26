//
//  Piece.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

/// A piece on the board.
protocol Piece: AnyObject {
    /// An ID for the piece. Only used to locate pieces on the board.
    var id: UUID { get }

    /// The graphical representation of the piece, Unicode symbols.
    var content: String { get }

    /// The type of piece
    var type: PieceType { get }

    /// The side that owns the piece
    var side: Side { get }

    /// Description of the piece, something like N for Knight and the graphical representation
    var desc: String { get }

    /// If the piece has made its first move yet
    var hasMoved: Bool { get set }

    /// A list of ways in which the piece can move.
    var movePatterns: [MovePattern] { get }

    /// Only the knight can move over other pieces
    var canMoveOverOtherPieces: Bool { get }

    /// Initialize a piece with the given side. This is really the only information that is not known
    /// at the time it is initialized.
    init(side: Side)
}
