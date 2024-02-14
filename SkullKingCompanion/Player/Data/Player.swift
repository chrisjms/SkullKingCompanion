//
//  Player.swift
//  SkullKingCompanion
//
//  Created by Christopher James on 09/02/2024.
//

import Foundation

struct Player {
    
    static let defaultName: String = "Player"
    
    let id: String
    let name: String
    let gameId: String
    let score: Int
    let bid: Int
    let trickWons: Int
    let bonusPoints: Int
}

extension Player {
    init(_ playerDb: PlayerDb) {
        self.id = playerDb.id
        self.name = playerDb.name
        self.gameId = playerDb.gameId
        self.score = playerDb.score
        self.bid = playerDb.bid
        self.trickWons = playerDb.trickWons
        self.bonusPoints = playerDb.bonusPoints
    }
}
