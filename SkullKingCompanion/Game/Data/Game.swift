//
//  Game.swift
//  SkullKingCompanion
//
//  Created by Christopher James on 09/02/2024.
//

import Foundation

struct Game {
    let id: String
    let state: GameState
    let roundNumber: Int
}

enum GameState: String, Codable {
    case notStarted
    case started
    case ended
}

extension Game {
    init(_ gameDb: GameDb) {
        self.id = gameDb.id
        self.state = gameDb.state
        self.roundNumber = gameDb.roundNumber
    }
}
