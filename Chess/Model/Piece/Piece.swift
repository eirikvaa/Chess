//
//  Piece.swift
//  Chess
//
//  Created by Eirik Vale Aase on 26/12/2019.
//  Copyright © 2019 Eirik Vale Aase. All rights reserved.
//

import Foundation

enum Direction {
    case north(single: Bool)
    case northEast(single: Bool)
    case east(single: Bool)
    case southEast(single: Bool)
    case south(single: Bool)
    case southWest(single: Bool)
    case west(single: Bool)
    case northWest(single: Bool)
}

struct MovePattern {
    let patterns: [Direction]
}

protocol Piece {
    var name: String { get }
    var player: Player? { get set }
    var graphicalRepresentation: String { get }
    var movePatterns: [MovePattern] { get }
}

struct King: Piece {
    var name = "King"
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♔" : "♚"
    }
    var movePatterns: [MovePattern] = [
        .init(patterns: [.north(single: true)]),
        .init(patterns: [.east(single: true)]),
        .init(patterns: [.south(single: true)]),
        .init(patterns: [.west(single: true)])
    ]
}

struct Queen: Piece {
    var name = "Queen"
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♕" : "♛"
    }
    var movePatterns: [MovePattern] = [
        .init(patterns: [.north(single: false)]),
        .init(patterns: [.northEast(single: false)]),
        .init(patterns: [.east(single: false)]),
        .init(patterns: [.southEast(single: false)]),
        .init(patterns: [.south(single: false)]),
        .init(patterns: [.southWest(single: false)]),
        .init(patterns: [.west(single: false)]),
        .init(patterns: [.northWest(single: false)])
    ]
}

struct Bishop: Piece {
    var name = "Runner"
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♗" : "♝"
    }
    var movePatterns: [MovePattern] = [
        .init(patterns: [.northEast(single: false)]),
        .init(patterns: [.southEast(single: false)]),
        .init(patterns: [.southWest(single: false)]),
        .init(patterns: [.northWest(single: false)]),
    ]
}

struct Rook: Piece {
    var name = "Rook"
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♖" : "♜"
    }
    var movePatterns: [MovePattern] = [
        .init(patterns: [.north(single: false)]),
        .init(patterns: [.west(single: false)]),
        .init(patterns: [.east(single: false)]),
        .init(patterns: [.south(single: false)])
    ]
}

struct Knight: Piece {
    var name = "Knight"
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♘" : "♞"
    }
    var movePatterns: [MovePattern] = [
        .init(patterns: [.north(single: true), .north(single: true), .west(single: true)]),
        .init(patterns: [.north(single: true), .north(single: true), .east(single: true)]),
        .init(patterns: [.north(single: true), .west(single: true), .west(single: true)]),
        .init(patterns: [.north(single: true), .east(single: true), .east(single: true)]),
        .init(patterns: [.south(single: true), .west(single: true), .west(single: true)]),
        .init(patterns: [.south(single: true), .east(single: true), .east(single: true)]),
        .init(patterns: [.south(single: true), .south(single: true), .west(single: true)]),
        .init(patterns: [.south(single: true), .south(single: true), .east(single: true)])
    ]
}

struct Pawn: Piece {
    var name = "Pawn"
    var player: Player?
    var graphicalRepresentation: String {
        player?.side == .white ? "♙" : "♟"
    }
    var movePatterns: [MovePattern] = [
        .init(patterns: [.north(single: true)]),
        .init(patterns: [.northEast(single: true)]),
        .init(patterns: [.northWest(single: true)])
    ]
}
