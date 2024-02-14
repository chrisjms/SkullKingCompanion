//
//  PlayerRepository.swift
//  SkullKingCompanion
//
//  Created by Christopher James on 09/02/2024.
//

import Foundation
import Combine
import GRDB

protocol PlayerRepository {
    func observePlayers(gameId: String) -> AnyPublisher<[Player], Error>
    func setPlayerScore(id: String, score: Int) async throws
    func setNewBid(id: String, bid: Int) async throws
    func setNewTricks(id: String, trickWons: Int) async throws
    func setNewBonusPoints(id: String, bonusPoints: Int) async throws
}

class PlayerOfflineRepository: PlayerRepository {
    
    private let database: AppDatabase
    
    init(database: AppDatabase) {
        self.database = database
    }
    
    func observePlayers(gameId: String) -> AnyPublisher<[Player], Error> {
        let observationScheduler: ValueObservationScheduler = .async(onQueue: DispatchQueue.global())
        
        let playersPub = ValueObservation.tracking { db in
            try PlayerDb
                .all()
                .filter(gameId: gameId)
                .fetchAll(db)
        }.publisher(in: database.dbWriter, scheduling: observationScheduler)
        
        return playersPub
            .map { playersDb in
                return playersDb.map { playerDb in
                    return Player(playerDb)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func setPlayerScore(id: String, score: Int) async throws {
        try await database.dbWriter.write { db in
            var playerDb = try PlayerDb
                .fetchOne(db, id: id)
            playerDb?.score += score
            try playerDb?.upsert(db)
        }
    }
    
    func setNewBid(id: String, bid: Int) async throws {
        try await database.dbWriter.write { db in
            var playerDb = try PlayerDb
                .fetchOne(db, id: id)
            playerDb?.bid = bid
            try playerDb?.upsert(db)
        }
    }
    
    func setNewTricks(id: String, trickWons: Int) async throws {
        try await database.dbWriter.write { db in
            var playerDb = try PlayerDb
                .fetchOne(db, id: id)
            playerDb?.trickWons = trickWons
            try playerDb?.upsert(db)
        }
    }
    
    func setNewBonusPoints(id: String, bonusPoints: Int) async throws {
        try await database.dbWriter.write { db in
            var playerDb = try PlayerDb
                .fetchOne(db, id: id)
            playerDb?.bonusPoints = bonusPoints
            try playerDb?.upsert(db)
        }
    }
}
