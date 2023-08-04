//
//  Board.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//

import Foundation

/// Representation of the board. Has the responsibility of allowing others to query the board for cells and pieces.
/// It does not modify itself in any way because that is the responsibility of whoever entity uses this class.
class Board: CustomStringConvertible {
    private let cells: [[Cell]]

    init() {
        let files = ["a", "b", "c", "d", "e", "f", "g", "h"]
        let ranks = 1 ... 8

        var matrix: [[Cell]] = []
        ranks.forEach { rank in
            var currentRow: [Cell] = []

            files.forEach { file in
                let coordinate = Coordinate(file: File(value: file), rank: Rank(value: rank))

                var piece: Piece?

                switch (file, rank) {
                case ("a", 1),
                     ("h", 1):
                    piece = Rook(side: .white)
                case ("b", 1),
                     ("g", 1):
                    piece = Knight(side: .white)
                case ("c", 1),
                     ("f", 1):
                    piece = Bishop(side: .white)
                case ("d", 1):
                    piece = Queen(side: .white)
                case ("e", 1):
                    piece = King(side: .white)
                case (_, 2):
                    piece = Pawn(side: .white)
                case ("a", 8),
                     ("h", 8):
                    piece = Rook(side: .black)
                case ("b", 8),
                     ("g", 8):
                    piece = Knight(side: .black)
                case ("c", 8),
                     ("f", 8):
                    piece = Bishop(side: .black)
                case ("d", 8):
                    piece = Queen(side: .black)
                case ("e", 8):
                    piece = King(side: .black)
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

    /// Get the cell from a pair of file and rank.
    /// TODO: Delete
    subscript(file: File, rank: Rank) -> Cell {
        return flattenedBoard().first { cell -> Bool in
            cell.coordinate.file == file && cell.coordinate.rank == rank
        }!
    }

    /// Get the cell from a coordinate.
    subscript(coordinate: Coordinate) -> Cell {
        self[coordinate.file!, coordinate.rank!]
    }

    func isEmptyCell(at coordinate: Coordinate) -> Bool {
        self[coordinate].piece == nil
    }

    func getCoordinates(
        from sourceCoordinate: Coordinate,
        to destinationCoordinate: Coordinate,
        given pattern: MovePattern
    ) -> [Coordinate] {
        switch pattern {
        case let .single(direction):
            guard let firstC = sourceCoordinate.applyDirection(direction) else {
                return []
            }

            guard firstC == destinationCoordinate else {
                return []
            }

            return [firstC]
        case let .double(first, second):
            guard let firstC = sourceCoordinate.applyDirection(first) else {
                return []
            }

            guard let secondC = firstC.applyDirection(second) else {
                return []
            }

            guard secondC == destinationCoordinate else {
                return []
            }

            return [firstC, secondC]
        case let .shape(first, second, third):
            guard let firstC = sourceCoordinate.applyDirection(first) else {
                return []
            }

            guard let secondC = firstC.applyDirection(second) else {
                return []
            }

            guard let thirdC = secondC.applyDirection(third) else {
                return []
            }

            return [firstC, secondC, thirdC]
        case let .continuous(direction):
            var currentCoordinate = sourceCoordinate
            var coordinates = [Coordinate]()

            while let nextCoordinate = currentCoordinate.applyDirection(direction) {
                coordinates.append(nextCoordinate)
                currentCoordinate = nextCoordinate

                if currentCoordinate == destinationCoordinate {
                    break
                }
            }

            return coordinates
        }
    }

    /// Get all pieces of a given piece type and from a given side.
    /// - parameters:
    ///    - type: The piece type
    ///    - side: The side, either white or black
    /// - returns: A list of cells at which the pieces where found
    func getAllPieces(of type: PieceType, side: Side, sourceCoordinate: Coordinate) -> [Cell] {
        let cells = flattenedBoard().filter {
            $0.piece?.type == type && $0.piece?.side == side
        }

        guard sourceCoordinate.rank != nil || sourceCoordinate.file != nil else {
            return cells
        }

        return cells.filter {
            $0.coordinate.rank == sourceCoordinate.rank || $0.coordinate.file == sourceCoordinate.file
        }
    }

    /// Get the cell of a given piece
    /// Returns a non-optional because we _must_ find the cell for which a piece resides.
    /// If the piece does not have a cell, it is not on the board, i.e. it must have a cell.
    /// - parameter piece: The piece for which we want to find a cell.
    /// - returns: The cell at which the piece resides.
    func getCell(of piece: Piece) -> Cell {
        return flattenedBoard().first(where: {
            $0.piece?.id == piece.id && $0.piece?.type == piece.type
        })!
    }

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
        return cells.reduce(into: []) { result, cells in
            result += cells
        }
    }
}
