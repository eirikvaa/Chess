//
//  Board.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

/**
 Representation of the board. Has the responsibility of allowing others to query the board for cells and pieces.
 It does not modify itself in any way because that is the responsibility of whoever entity uses this class.
 */
class Board: CustomStringConvertible {
    private let cells: [[Cell]]

    init() {
        let files = ["a", "b", "c", "d", "e", "f", "g", "h"]
        let ranks = 1...8

        var matrix: [[Cell]] = []
        ranks.forEach { rank in
            var currentRow: [Cell] = []

            files.forEach { file in
                let coordinate = Coordinate(file: File(value: file), rank: Rank(value: rank))

                var piece: Piece?

                switch (file, rank) {
                case ("a", 1),
                     ("h", 1):
                    break//piece = Rook(side: .white)
                case ("b", 1),
                     ("g", 1):
                    break//piece = Knight(side: .white)
                case ("c", 1),
                     ("f", 1):
                    break//piece = Bishop(side: .white)
                case ("d", 1):
                    piece = Queen(side: .white)
                case ("e", 1):
                    break//piece = King(side: .white)
                case (_, 2):
                    piece = Pawn(side: .white)
                case ("a", 8),
                     ("h", 8):
                    break//piece = Rook(side: .black)
                case ("b", 8),
                     ("g", 8):
                    break//piece = Knight(side: .black)
                case ("c", 8),
                     ("f", 8):
                    break//piece = Bishop(side: .black)
                case ("d", 8):
                    piece = Queen(side: .black)
                case ("e", 8):
                    break//piece = King(side: .black)
                case (_, 7):
                    piece = Pawn(side: .black)
                default:
                    break
                }

                let cell = Cell(coordinate: coordinate, piece: piece)
                currentRow.append(cell)
            }

            matrix.insert(currentRow, at: 0)
        }

        self.cells = matrix
    }

    /**
     Get the cell from a pair of file and rank.
     */
    // TODO: Delete
    subscript(file: File, rank: Rank) -> Cell {
        return flattenedBoard().filter { cell in
            cell.coordinate.file == file && cell.coordinate.rank == rank
        }.first!
    }

    /**
     Get the cell from a coordinate.
     */
    subscript(coordinate: Coordinate) -> Cell {
        self[coordinate.file, coordinate.rank]
    }

    /**
     Get all pieces of a given piece type and from a given side.
     - Parameters:
        - type: The piece type
        - side: The side, either white or black
     - Returns: A list of cells at which the pieces where found
     */
    func getAllPieces(of type: PieceType, side: Side) -> [Cell] {
        flattenedBoard().filter {
            $0.piece?.type == type && $0.piece?.side == side
        }
    }

    /**
     Get the cell of a given piece
     Returns a non-optional because we _must_ find the cell for which a piece resides.
     If the piece does not have a cell, it is not on the board, i.e. it must have a cell.
     - Parameter piece: The piece for which we want to find a cell.
     - Returns: The cell at which the piece resides.
     */
    func getCell(of piece: Piece) -> Cell {
        return flattenedBoard().first(where: {
            $0.piece?.id == piece.id && $0.piece?.type == piece.type
        })!
    }

    /**
     Check if the given piece can be moved to the given coordinate with the given move pattern.
     - Parameters:
        - piece: The piece to move
        - destinationCoordinate: The coordinate to move to
        - movePattern: The move pattern with which to move the piece to the coordinate
     - Returns: True if the piece can be moved, false otherwise
     */
    /*func piece(piece: Piece, canMoveTo destinationCoordinate: Coordinate, with movePattern: MovePattern, move: Move) -> Bool {
        let oldCoordinate = getCell(of: piece).coordinate
        
        switch movePattern.moveType {
        case .single:
            let nextCoordinate = oldCoordinate.applyDirection(movePattern.directions[0])
            return oldCoordinate == nextCoordinate
        case .double:
            let direction = movePattern.directions[0]
            let nextCoordinate = oldCoordinate
                .applyDirection(direction)
                .applyDirection(direction)
            return oldCoordinate == nextCoordinate
        case .straight:
            let direction = movePattern.directions[0]
            var currentCoordinate = oldCoordinate
            while true {
                currentCoordinate = currentCoordinate.applyDirection(direction)
                
                if oldCoordinate == currentCoordinate {
                    return true
                }
            }
        default:
            break
        }
        
        var currentCoordinate = oldCoordinate
        movePattern.directions.forEach {
            currentCoordinate = currentCoordinate.applyDirection($0)
        }
        
        return currentCoordinate == destinationCoordinate
    }*/

    var description: String {
        var desc = "    a   b   c   d   e   f   g   h\n"
        desc += "   ––– ––– ––– ––– ––– ––– ––– ––– \n"

        for (index, rank) in cells.enumerated() {
            desc += "\(8 - index) |"

            for cell in rank {
                let cellContent = cell.piece?.content ?? " "
                desc += " " + cellContent + " |"
            }

            desc += " \(8 - index)\n   ––– ––– ––– ––– ––– ––– ––– ––– \n"
        }

        desc += "    a   b   c   d   e   f   g   h\n"

        return desc
    }
}

private extension Board {
    func flattenedBoard() -> [Cell] {
        cells.reduce([]) { allCells, currentRow -> [Cell] in
            allCells + currentRow
        }
    }
}
