//
//  Piece.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

protocol Piece {
    var id: String { get }
    var type: PieceType { get }
    var side: Side { get set }
    var graphicalRepresentation: String { get }
    var movePatterns: [MovePattern] { get }
    var moved: Bool { get set }
    func numberOfMoves(for movePattern: MovePattern) -> Int
    
    func validPattern(delta: Delta, side: Side, isAttacking: Bool) -> MovePattern
}
