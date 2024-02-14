//
//  LobbyViewModel.swift
//  SkullKingCompanion
//
//  Created by Christopher James on 09/02/2024.
//

import Foundation
import Combine

@MainActor
class LobbyViewModel: ObservableObject {
    
    private let gameRepository: GameRepository
    private var cancellables = Set<AnyCancellable>()

    @Published private (set) var startedGames = [Game]()
    
    init(gameRepository: GameRepository) {
        self.gameRepository = gameRepository
        
        gameRepository.observeStartedGames()
            .sink { _ in
            } receiveValue: { [weak self] games in
                self?.startedGames = games
            }
            .store(in: &cancellables)
    }
}
