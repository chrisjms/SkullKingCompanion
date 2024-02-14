//
//  GameRepository.swift
//  SkullKingCompanion
//
//  Created by Christopher James on 09/02/2024.
//

import Foundation
import Combine
import GRDB

protocol GameRepository {
    func observeStartedGames() -> AnyPublisher<[Game], Error>
    func observeGame(id: String) -> AnyPublisher<Game?, Error>
    func startNewGame(gameId: String, playerItems: [PlayerItem]) async throws
    func onNextRound(id: String) async throws
}

class GameOfflineRepository: GameRepository {
    
    private let database: AppDatabase
    
    init(database: AppDatabase) {
        self.database = database
    }
    
    func observeStartedGames() -> AnyPublisher<[Game], Error> {
        let observationScheduler: ValueObservationScheduler = .async(onQueue: DispatchQueue.global())
        
        let gamesPub = ValueObservation.tracking { db in
            try GameDb
                .all()
                .filterStartedGames()
                .fetchAll(db)
        }.publisher(in: database.dbWriter, scheduling: observationScheduler)
        
        return gamesPub
            .map { gamesDb in
                return gamesDb.map { gameDb in
                    return Game(gameDb)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func observeGame(id: String) -> AnyPublisher<Game?, Error> {
        let observationScheduler: ValueObservationScheduler = .async(onQueue: DispatchQueue.global())
        
        let gamesPub = ValueObservation.tracking { db in
            try GameDb
                .fetchOne(db, id: id)
        }.publisher(in: database.dbWriter, scheduling: observationScheduler)
        
        return gamesPub
            .map { gameDb in
                guard let gameDb else { return nil }
                return Game(gameDb)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func startNewGame(gameId: String, playerItems: [PlayerItem]) async throws {
        try await database.dbWriter.write { db in
            try GameDb(id: gameId, state: .started, roundNumber: 1).upsert(db)
            try playerItems.forEach { playerItem in
                try PlayerDb(
                    id: playerItem.id,
                    name: playerItem.name,
                    gameId: gameId,
                    score: 0,
                    bid: 0,
                    trickWons: 0,
                    bonusPoints: 0
                ).upsert(db)
            }
        }
    }
    
    func onNextRound(id: String) async throws {
        try await database.dbWriter.write { db in
            // mettre ici les changements de score?
            var gameDb = try GameDb
                .fetchOne(db, id: id)
            if gameDb?.roundNumber == 10 {
                gameDb?.state = .ended
            } else {
                gameDb?.roundNumber += 1
            }
            try gameDb?.update(db)
        }
    }
}
