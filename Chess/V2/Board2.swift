//
//  Board.swift
//  Chess
//
//  Created by Eirik Vale Aase on 05/12/2020.
//  Copyright © 2020 Eirik Vale Aase. All rights reserved.
//

class Board: CustomStringConvertible {
    var cells: [[Cell]] = []
    
    init() {
        let files = ["a", "b", "c", "d", "e", "f", "g", "h"]
        let ranks = 1...8
        
        var matrix: [[Cell]] = []
        ranks.forEach { rank in
            var currentRow: [Cell] = []
            
            files.forEach { file in
                let coordinate = Coordinate(file: file, rank: rank)
                
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
    
    func getAllPieces(type: PieceType, side: Side) -> [Cell] {
        cells.reduce([]) { (pieces, row) -> [Cell] in
            pieces + row.compactMap { $0 }.filter {
                $0.piece?.type == type && $0.piece?.side == side
            }
        }
    }
    
    var description: String {
        var _description = "    a   b   c   d   e   f   g   h\n"
        _description += "   ––– ––– ––– ––– ––– ––– ––– ––– \n"

        for (index, rank) in cells.enumerated() {
            _description += "\(8 - index) |"

            for cell in rank {
                let cellContent = cell.piece?.content ?? " "
                _description += " " + cellContent + " |"
            }

            _description += " \(8 - index)\n   ––– ––– ––– ––– ––– ––– ––– ––– \n"
        }

        _description += "    a   b   c   d   e   f   g   h\n"

        return _description
    }
}
