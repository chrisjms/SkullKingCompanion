//
//  GameDb.swift
//  SkullKingCompanion
//
//  Created by Christopher James on 09/02/2024.
//

import GRDB

struct GameDb: Identifiable, Codable, PersistableRecord, FetchableRecord, Equatable {
    let id: String
    var state: GameState
    var roundNumber: Int

    fileprivate enum Columns {
        static let id = Column(CodingKeys.id)
        static let state = Column(CodingKeys.state)
        static let roundNumber = Column(CodingKeys.roundNumber)
    }
}

extension DerivableRequest<GameDb> {
    func filterStartedGames() -> Self {
        filter(GameDb.Columns.state == "started")
    }
}
