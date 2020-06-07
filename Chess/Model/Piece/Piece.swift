//
//  Piece.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

protocol Piece {
    var id: String { get }
    var side: Side { get set }
    var type: PieceType { get }
    var moved: Bool { get set }
    var graphicalRepresentation: String { get }

    func validPattern(source: BoardCoordinate, destination: BoardCoordinate, move: Move) -> MovePattern
}
