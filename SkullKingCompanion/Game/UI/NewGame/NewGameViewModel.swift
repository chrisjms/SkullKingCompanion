//
//  NewGameViewModel.swift
//  SkullKingCompanion
//
//  Created by Christopher James on 09/02/2024.
//

import Foundation

struct PlayerItem {
    let id: String
    var name: String
}

@MainActor
class NewGameViewModel: ObservableObject {
    
    @Published var playerItems: [PlayerItem]
    @Published private (set) var gameId: String

    private let gameRepository: GameRepository
    
    init(gameRepository: GameRepository) {
        self.playerItems = [
            PlayerItem(id: UUID().uuidString, name: Player.defaultName + " 1"),
            PlayerItem(id: UUID().uuidString, name: Player.defaultName + " 2")
        ]
        self.gameRepository = gameRepository
        self.gameId = UUID().uuidString
    }
    
    func onAddPlayer() {
        let playersNumber = playerItems.count
        guard playersNumber < 8 else { return }
        let newPlayer = PlayerItem(id: UUID().uuidString, name: Player.defaultName + " \(playersNumber + 1)")
        self.playerItems.append(newPlayer)
    }
    
    func onStartNewGame() {
        Task {
            do {
                try await gameRepository.startNewGame(gameId: gameId, playerItems: playerItems)
            } catch {
                print("Error starting new game")
            }
        }
    }
}
