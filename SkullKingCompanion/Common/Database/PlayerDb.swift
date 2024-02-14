//
//  PlayerDb.swift
//  SkullKingCompanion
//
//  Created by Christopher James on 09/02/2024.
//

import GRDB

struct PlayerDb: Identifiable, Codable, PersistableRecord, FetchableRecord, Equatable {
    let id: String
    let name: String
    let gameId: String
    var score: Int
    var bid: Int
    var trickWons: Int
    var bonusPoints: Int
    
    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
        static let name = Column(CodingKeys.name)
        static let gameId = Column(CodingKeys.gameId)
        static let score = Column(CodingKeys.score)
        static let bid = Column(CodingKeys.bid)
        static let trickWons = Column(CodingKeys.trickWons)
        static let bonusPoints = Column(CodingKeys.bonusPoints)
    }
}

extension DerivableRequest<PlayerDb> {
    func filter(gameId: String) -> Self {
        filter(PlayerDb.Columns.gameId == gameId)
    }
}
