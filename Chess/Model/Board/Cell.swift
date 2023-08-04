//
//  Cell.swift
//  Chess
//
//  Created by Eirik Vale Aase on 28/12/2019.
//

/// Represents a cell in the chess board.
class Cell: CustomStringConvertible {
    /// The coordinate of the cell. Cannot be changed, only read.
    let coordinate: Coordinate

    /// An optional piece that can reside in this cell.
    var piece: Piece?

    init(coordinate: Coordinate, piece: Piece?) {
        self.coordinate = coordinate
        self.piece = piece
    }

    var description: String {
        // TODO: Print piece also
        String(describing: coordinate)
    }
}
