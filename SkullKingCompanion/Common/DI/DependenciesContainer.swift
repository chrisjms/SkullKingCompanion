//
//  DependenciesContainer.swift
//  SkullKingCompanion
//
//  Created by Christopher James on 09/02/2024.
//

import Foundation

@MainActor
class DependenciesContainer: ObservableObject {
    
    lazy var database: AppDatabase = AppDatabase()
    
    lazy var gameRepository: GameRepository = GameOfflineRepository(database: database)
    lazy var playerRepository: PlayerRepository = PlayerOfflineRepository(database: database)
    lazy var scoreCalculator: ScoreCalculator = ScoreCalculator()
    
    func makeLobbyViewModel() -> LobbyViewModel {
        return LobbyViewModel(gameRepository: gameRepository)
    }
    
    func makeNewGameViewModel() -> NewGameViewModel {
        return NewGameViewModel(gameRepository: gameRepository)
    }
    
    func makeRoundViewModel(gameId: String) -> RoundViewModel {
        return RoundViewModel(
            gameId: gameId,
            scoreCalculator: scoreCalculator,
            gameRepository: gameRepository,
            playerRepository: playerRepository
        )
    }
}
